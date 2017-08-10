class SentEmailOpen < ActiveRecord::Base
  attr_accessible :email, :ip_address, :activity_id, :name, :opened

  belongs_to :activity, :dependent => :destroy
end
