module SelfControl
  module ControllerAdditions
    extend ActiveSupport::Concern
    
    module InstanceMethods      
      def steps_list
        @selfcontrol_steps = valid_selfcontrol? ? selfcontrol.steps_for(selfcontrol_actor) : []
        respond_with(@selfcontrol_steps)
      end
      
      def start_step        
        authorize_selfcontrol_step!
        
        if action_methods.include?(params[:id])
          send(params[:id])
        else
          render params[:id]
        end
      end
      
      def do_step
        authorize_selfcontrol_step!
        selfcontrol.do!(params[:id],params[:choose],params[:self_control_step])
        respond_with(selfcontrol_resource, :location => selfcontrol_resource_location)
      end

    protected
      
      def default_selfcontrol_actor
        respond_to?(:current_user) ? send(:current_user) : nil
      end
      
      def selfcontrol_actor
        @selfcontrol_actor ||= default_selfcontrol_actor
      end
      
      def default_selfcontrol_resource
        instance_name = params[:controller].sub("Controller", "").underscore.split('/').last.singularize
        instance_variable_get("@#{instance_name}")
      end
      
      def selfcontrol_resource
        @selfcontrol_resource ||= default_selfcontrol_resource
      end
      
      def selfcontrol_resource_location
        selfcontrol_resource
      end
      
      def selfcontrol
        @selfcontrol ||= valid_selfcontrol? ? selfcontrol_resource.selfcontrol : nil
      end

      def selfcontrol_step
        @selfcontrol_step ||= selfcontrol.nil? ? nil : selfcontrol[params[:id].to_sym]
      end
            
      def valid_selfcontrol?
        !selfcontrol_resource.nil? &&
        selfcontrol_resource.respond_to?(:selfcontrol) &&
        selfcontrol_resource.selfcontrol.is_a?(SelfControl::Flow)        
      end
      
      def valid_selfcontrol_step?
        !!selfcontrol_step
      end
      
      def allow_selfcontrol_step?
        return false unless selfcontrol.is_a?(SelfControl::Flow)
        selfcontrol.allow? selfcontrol_actor, :to => params[:id]
      end
      
      def authorize_selfcontrol_step!
        raise SelfControl::NotImplemented.new() unless valid_selfcontrol_step?
        unless allow_selfcontrol_step?
          raise SelfControl::AccessDenied.new(nil, selfcontrol_actor, params[:step], params[:choose])
        end
      end
        
    end
  end
end