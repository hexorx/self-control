module SelfControl
  module Helper
    def start_step_url_for(step, action_name)
      return unless action = step[action_name.to_sym]
      action.start_url(self).html_safe
    end 
  end
end