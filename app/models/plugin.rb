class Plugin < ActiveRecord::Base
  attr_accessible :is_active, :name, :url
end
