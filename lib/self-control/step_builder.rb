module SelfControl
  class StepBuilder
    attr_reader :name, :label, :actor, :actions, :default, :if, :unless, :meta
    
    def initialize(actor, options)
      @actor = actor
      @actions = [*options.delete(:should)].flatten.compact.uniq.map(&:to_sym)
      @default = options.delete(:action) || (@actions.size == 1 ? @actions.first : nil)
      
      @name = (options.delete(:to) || @actions.join('_or_')).to_sym
      @label = options.delete(:when) || @name.to_s.titleize
      
      @if = options.delete(:if)
      @unless = options.delete(:unless)
      
      @doable = !!(@if || @unless)
      
      @meta = options
    end
    
    def doable?
      @doable
    end
  end
end