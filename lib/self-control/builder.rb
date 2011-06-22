module SelfControl
  class Builder
    attr_accessor :klass, :actions, :flows, :state_column
    
    def initialize(klass, state_column=false, &block)
      @state_column = (state_column ? state_column.to_sym : false)
      @klass = klass
      @actions = {}
      @flows = {}
      instance_eval(&block)
    end
    
    private
    
    def to(action,options={})
      action = action.to_sym
      @actions[action] = SelfControl::Action.new(action, options)
    end
    
    def steps(options={}, &block)
      state = (options.delete(:when) || :default).to_sym
      @flows[state] = SelfControl::FlowBuilder.new(state, &block)
    end
  end
end

