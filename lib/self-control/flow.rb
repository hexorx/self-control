module SelfControl
  class Flow
    delegate :actions, :action_list, :total, :total_doable, :to => :@builder
    attr_reader :builder, :model
    
    def initialize(builder, model)
      @builder = builder
      @model = model
      @step_map = {}
    end
    
    def [](step_name)
      return if step_name.nil?
      name = step_name.to_sym
      @step_map[name] ||= steps.detect { |step| step.name == name }
    end
        
    def steps
      @steps ||= @builder.steps.map { |step| SelfControl::Step.new(step, self) }
    end
    
    def steps_for(actor)
      steps.select { |step| step.allow?(actor) }
    end
    
    def next_step_for(actor)
      steps.detect { |step| step.doable? && !step.done? && step.allow?(actor) }
    end
    
    def completed_steps
      steps.select(&:done?)
    end
    
    def total_completed
      completed_steps.size
    end
    
    def progress(options={})
      count = (options[:of] || :all).to_sym == :doable ? total_doable : total 
      
      case (options[:as] || :percent).to_sym
      when :percent
        count == 0 ? 100 : (total_completed / count.to_f) * 100
      when :decimal
        count == 0 ? 1.0 : (total_completed / count)
      when :array
        [total_completed, count]
      when :string
        [total_completed, count].join(options[:with] || ' / ')
      end
    end
    
    def done?
      total_completed == total_doable
    end
    
    def allow?(actor=nil,options={})
      return false unless step = self[options[:to]]
      step.allow?(actor)
    end

    def trigger!(*args)
      options = args.extract_options!
      return false unless step = self[args[0]]
      step.trigger!(args[1],options)
    end
  end
end

