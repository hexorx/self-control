module ActionDispatch::Routing
  class Mapper
    def selfcontrol
      get 'steps', :action => 'steps_list', :as => 'self_control_steps_list'
      get 'steps/:id', :action => 'start_step', :as => 'self_control_steps'
      post 'steps/:id(/:choose)', :action => 'do_step', :as => 'self_control_steps'
    end
    
    def control_resources(*resources, &block)
      resources(*resources) do
        selfcontrol
        yield if block_given? 
      end
    end
  end
end

