module SelfControl
  class Step
    include ActiveModel::Conversion
    include ActiveModel::Validations
    extend ActiveModel::Naming
    extend ActiveModel::Translation
    
    def persisted?
      true
    end
    
    def to_key
      [model_name, model_id, name]
    end
    
    def as_json(options={})
      {
        :id => to_param,
        :name => name,
        :actor => actor_method,
        :actions => actions,
        :default => default,
        :doable => doable?,
        :done => done?,
        :meta => meta
      }
    end
  end
  
  class Action
    include ActionView::Helpers::UrlHelper
  end
end