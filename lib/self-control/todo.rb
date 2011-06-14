module SelfControl
  class Todo
    attr_accessor :meta
    
    def initialize(actor, options)
      @meta = options
    end    
  end
end