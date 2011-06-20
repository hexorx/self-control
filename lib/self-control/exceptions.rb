module SelfControl
  class Error < StandardError; end

  class NotImplemented < Error; end

  class AccessDenied < Error
    attr_reader :subject, :step, :action
    attr_writer :default_message

    def initialize(message=nil, subject=nil, step=nil, action=nil)
      @message = message
      @subject = subject
      @step = step
      @action = action
      @default_message = "You are not authorized to access this step."
    end

    def to_s
      @message || @default_message
    end
  end  
end