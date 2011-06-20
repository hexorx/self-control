module SelfControl
  class Step
    delegate :name, :default, :actions, :doable?, :meta, :to => :@builder

    attr_accessor :model
    
    def initialize(builder, flow)
      @builder = builder
      @flow = flow
      @model = flow.model
    end
    
    def done?
      doable? && condition?(@builder.if || true) &&  !condition?(@builder.unless || false)
    end
        
    def condition?(attr)
      return attr if attr.is_a?(Boolean)

      result = if attr.is_a?(Proc)
        attr.call(*[@model,@builder].take(attr.arity >= 0 ? attr.arity : 0))
      elsif @model.respond_to?(attr)
        @model.send(attr)
      else
        false
      end

      (result == 0 ? false : result.present?)
    end
    
    def actor_method
      return if @builder.actor.nil?
      @builder.actor.to_sym
    end
    
    def model_name
      ActiveModel::Naming.singular(@model) if defined?(ActiveModel::Naming)
    end
    
    def actor
      return if actor_method.nil?
      @model.respond_to?(actor_method) ? @model.send(actor_method) : nil
    end
    
    def allow?(person=nil)
      actor ? person == actor : true
    end
    
    def do!(*args)
      options = args.extract_options!
      action = options.delete(:choose) || args[0] || default
      return false unless action && actions.include?(action.to_sym) && @model.respond_to?(action)
      
      @model.attributes = options[model_name] if options[model_name]
      @model.send(action)
      @model.save
    end    
  end
end

