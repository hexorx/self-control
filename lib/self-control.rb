require 'active_support'
require 'self-control/flow'
require 'self-control/todo'
require 'self-control/routes'

module SelfControl
  extend ActiveSupport::Concern
  
  module ClassMethods
    attr_reader :control_list
        
    def selfcontrol(options={}, &block)
      state = options[:when]
      @control_list ||= {}
      @control_list[state] = SelfControl::Flow.new(state, &block)
    end    
  end
  
  module InstanceMethods
    def control_list
      self.class.control_list
    end
  end
end

require 'self-control/railtie' if defined?(Rails)