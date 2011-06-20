module SelfControl
  class Step
    include ActiveModel::Conversion
    include ActiveModel::Validations
    extend ActiveModel::Naming
    extend ActiveModel::Translation
    
    def persisted?
      false
    end
    
    def as_json(options={})
      {
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
end