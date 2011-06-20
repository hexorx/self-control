require 'active_support'
require 'self-control/exceptions'

module SelfControl
  extend ActiveSupport::Concern
  
  module ClassMethods
    attr_reader :selfcontrol_list
    attr_writer :selfcontrol_column
    
    def selfcontrol(state=nil, options={}, &block)
      state = (state || options[:when]).to_sym
      @selfcontrol_list ||= {}
      @selfcontrol_list[state] = SelfControl::FlowBuilder.new(state, &block)
    end
    
    alias :control_when :selfcontrol
    
    def selfcontrol_column
      @selfcontrol_column ||= 'state'
    end
  end
  
  module InstanceMethods
    def selfcontrol_list
      self.class.selfcontrol_list
    end
    
    def selfcontrol_column
      self.class.selfcontrol_column
    end
        
    def current_selfcontrol_state
      (self.respond_to?(selfcontrol_column) ? self.send(selfcontrol_column) : :default).to_sym
    end
    
    def selfcontrol(state=current_selfcontrol_state)
      return unless builder = self.selfcontrol_list[state]
      @selfcontrol_flows ||= {}
      @selfcontrol_flows[state] ||= SelfControl::Flow.new(builder,self)
    end
  end
  
  autoload :FlowBuilder, 'self-control/flow_builder'
  autoload :StepBuilder, 'self-control/step_builder'
  autoload :Flow, 'self-control/flow'
  autoload :Step, 'self-control/step'
end

require 'self-control/railtie' if defined?(Rails)