module SelfControl
  module Helper
    def step_url_for(resource, action_name, options={})
      return unless resource
      return unless builder = resource.selfcontrol_builder
      action_name = action_name.to_sym
      action = builder.actions[action_name] || SelfControl::Action.new(action_name, options)
      action.url_from(resource,self).html_safe
    end 
  end
end