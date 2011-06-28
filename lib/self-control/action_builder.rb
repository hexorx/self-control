module SelfControl
  class ActionBuilder
    attr_reader :name, :label, :trigger, :goto, :hash, :arguments, :meta, :if, :unless, :options
        
    def initialize(name, options={})
      @name = name.to_sym
      @label = options.delete(:as) || @name.to_s.titleize
      @trigger = options.delete(:trigger) || @name
      @goto = options.delete(:goto)
      @hash = options.delete(:hash)
      @arguments = options.delete(:the) || options.delete(:for) || {}
      @meta = options.delete(:meta) || options.delete(:with) || {}
      
      @if = options.delete(:if)
      @unless = options.delete(:unless)
      
      @options = options
    end    
  end
end