module SelfControl
  class Action
    attr_accessor :name, :goto, :for, :options
        
    def initialize(name, options={})
      @name = name
      @goto = options.delete(:goto)
      @hash = options.delete(:hash)
      @arguments = options.delete(:the) || options.delete(:for) || options.delete(:with)
    end
    
    def url_from(model, env)      
      goto = in_context(@goto, model, env)
      hash = in_context(@hash, model, env)
      args = in_context(@arguments, model, env)
      
      url = if goto.is_a?(String) then goto
      elsif goto.is_a?(Symbol)
        env.send(goto, args)
      else
        env.send(:url_for, (goto || args))
      end
      
      hash ? "#{url}##{hash}" : url
    end
    
    def in_context(option, model, env)
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
        option.map { |opt| in_context(opt, model, env) }
      when Hash
        Hash[option.map { |k,v| [k.to_sym, in_context(v, model, env)] }]
      when Proc
        option.call(*[model,env].take(option.arity >= 0 ? option.arity : 0))
      end      
    end    
  end
end