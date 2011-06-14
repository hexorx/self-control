module ActionDispatch::Routing
  class Mapper
    def selfcontrol
      get ':event', :on => :member, :action => parent_resource.name, :as => "#{parent_resource.name}_selfcontrol"
    end
  end
end

