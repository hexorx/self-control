module SelfControl
  class Flow
    attr_accessor :state, :todos
    
    def initialize(state, &flow)
      @state = state
      instance_eval(&flow)
    end
    
    private
    
    def the(actor, options)
      @todos ||= []
      @todos.push SelfControl::Todo.new(actor, options)
    end    
  end
end