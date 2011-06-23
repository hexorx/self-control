require 'self-control/helper'
require 'self-control/adapter'
require 'self-control/route_helpers'
require 'self-control/controller_extensions'

module SelfControl
  class Railtie < Rails::Railtie
    initializer 'selfcontrol.load_helpers' do |app|
      ActionController::Base.helper(SelfControl::Helper)
    end
  end
end