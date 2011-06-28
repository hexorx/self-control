module SelfControl
  class Action
    delegate :name, :label, :trigger, :goto, :hash, :arguments, :meta, :to => :@builder
    delegate :model, :in_context, :to => :@step
    
    def initialize(builder, step)
      @builder = builder
      @step = step      
    end
        
    def start_url(env=self)
      processed_goto = goto!(env)
      processed_hash = hash!(env)
      processed_args = args!(env)
      
      url = case processed_goto
      when String then processed_goto
      when Symbol then env.send(processed_goto, processed_args)
      else
        resource = (processed_goto || processed_args)
        env.send(:url_for, resource) if resource.present?
      end
      
      "#{url}#{processed_hash}" if url
    end
    
    def label!(env=self)
      in_context(label, env)
    end
    
    def goto!(env=self)
      in_context(goto, env)
    end
        
    def trigger!(env=self)
      return false unless trigger?(env)
      begin
        in_context(trigger, env)
      rescue
        false
      end
    end
    
    def hash!(env=self)
      results = in_context(hash, env)
      "##{results}" if results
    end

    def args!(env=self)
      in_context(arguments, env)
    end

    def meta!(env=self)
      in_context(meta, env)
    end
    
    def trigger?(env=self)
      return true unless @builder.if || @builder.unless
      !condition?(@builder.if || false, env) && condition?(@builder.unless || true, env)
    end
    
    def condition?(option, env=self)
      @step.condition?(option, env)
    end    
  end
end