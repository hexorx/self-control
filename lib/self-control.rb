require 'active_support'
require 'self-control/exceptions'

module SelfControl
  extend ActiveSupport::Concern
  
  module ClassMethods
    attr_reader :selfcontrol_builder
    
    def selfcontrol(options={}, &block)
      state_column = options.delete(:for)
      @selfcontrol_builder = SelfControl::Builder.new(self, state_column, &block)
    end
    
    alias :flowcontrol :selfcontrol    
  end
  
  module InstanceMethods    
    def selfcontrol_builder
      self.class.selfcontrol_builder
    end
        
    def selfcontrol(state=nil)
      return false unless selfcontrol_builder.is_a?(SelfControl::Builder)

      state ||= :default unless state_column = selfcontrol_builder.state_column
      state ||= (self.respond_to?(state_column) ? self.send(state_column) : :default).to_sym

      @selfcontrol_flows ||= {}
      return @selfcontrol_flows[state] if @selfcontrol_flows[state].is_a?(SelfControl::Flow)

      return false unless builder = selfcontrol_builder.flows[state]
      @selfcontrol_flows[state] = SelfControl::Flow.new(builder, self)
    end    
  end
  
  autoload :Builder, 'self-control/builder'
  autoload :FlowBuilder, 'self-control/flow_builder'
  autoload :StepBuilder, 'self-control/step_builder'
  autoload :Flow, 'self-control/flow'
  autoload :Step, 'self-control/step'
  autoload :Action, 'self-control/action'
end

require 'self-control/railtie' if defined?(Rails)