module SelfControl
  class Step
    delegate :name, :default, :doable?, :meta, :to => :@builder
    delegate :model, :action_list, :to => :@flow
    
    def initialize(builder, flow)
      @builder = builder
      @flow = flow
      @model = @flow.model
      @action_map = {}
    end
    
    def [](action_name)
      @action_map[action_name.to_sym] ||= build_action(action_name)
    end
    
    def build_action(action_name)
      return unless action_names.include?(name = action_name.to_sym)
      builder = action_list[name] || SelfControl::ActionBuilder.new(name)
      SelfControl::Action.new(builder, self)
    end
    
    def actions
      @actions ||= (action_names.map { |action_name| self[action_name] }).compact
    end
    
    def action_names
      @builder.actions
    end
    
    def actor_method
      return if @builder.actor.nil?
      @builder.actor.to_sym
    end
    
    def model_id
      @model.id if @model.respond_to?(:id)
    end
    
    def model_name
      ActiveModel::Naming.singular(@model) if defined?(ActiveModel::Naming)
    end

    def model_collection
      ActiveModel::Naming.plural(@model) if defined?(ActiveModel::Naming)
    end
    
    def actor
      return if actor_method.nil?
      @model.respond_to?(actor_method) ? @model.send(actor_method) : nil
    end
    
    def trigger!(*args)
      options = args.extract_options!
      action_name = options.delete(:choose) || args[0] || default
      return false unless action_name && (action = self[action_name.to_sym])
      @model.attributes = options[model_name] if options[model_name]
      if action.trigger!(@model) then @model.save
      else
        @model.valid?
        false
      end
    end
    
    def done?
      doable? && !condition?(@builder.if || false) && condition?(@builder.unless || true)
    end
        
    def condition?(option, env=self)
      result = in_context(option, env)
      (result == 0 ? false : result.present?)
    end    
    
    def allow?(person=nil)
      actor ? person == actor : true
    end
    
    def in_context(option, env=self)
      return option if option.is_a?(Boolean)
      case option
      when String then option
      when Symbol
        if model.respond_to?(option) then model.send(option)
        elsif option.to_s.starts_with?('@')
          env.instance_variable_get(option)
        else
          option
        end
      when Array
        option.map { |opt| in_context(opt, env) }
      when Hash
        Hash[option.map { |k,v| [k.to_sym, in_context(v, env)] }]
      when Proc
        option.call(*[model,env].take(option.arity >= 0 ? option.arity : 0))
      end      
    end
  end
end

