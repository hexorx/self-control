require 'self-control/helper'
require 'self-control/step_adapter'
require 'self-control/route_helpers'
require 'self-control/controller_extensions'

module SelfControl
  class Railtie < Rails::Railtie
    initializer 'selfcontrol.app_controller' do |app|
      ActionController::Base.helper(SelfControl::Helper)
      ActiveSupport.on_load(:application_controller) do
        include SelfControl::ControllerExtensions
      end
    end
  end
end