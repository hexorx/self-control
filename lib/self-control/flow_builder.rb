module SelfControl
  class FlowBuilder
    attr_accessor :state, :steps, :actors, :actions
    
    def initialize(state, &flow)
      @state = state
      @steps ||= []
      @actors ||= []
      @actions ||= []
      
      instance_eval(&flow)
      
      @actors = @actors.flatten.compact.uniq
      @actions = @actions.flatten.compact.uniq
    end
    
    def total
      @steps.size
    end
    
    def doable_steps
      @steps.select(&:doable?)
    end
    
    def total_doable
      doable_steps.size
    end
    
    private
    
    def the(actor, options)
      step = SelfControl::StepBuilder.new(actor, options)
      @steps.push(step)
      @actors.push(step.actor)
      @actions.concat(step.actions)
    end
    
    def someone(options)
      the(nil,options)
    end
    
    def they(options)
      the(@actors.last,options)
    end
  end
end

