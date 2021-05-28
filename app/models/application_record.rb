class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  def broadcast

    name = self.class.name.underscore

    ActionCable.server.broadcast "#{name}:user_id:#{user_id}", 
          {   id: id,
              data: self.to_json,
              html: ApplicationController.render("/#{name.pluralize}/_row", layout:nil, locals: {"#{name}": self})
          }
  end
end
