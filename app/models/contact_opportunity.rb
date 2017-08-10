class ContactOpportunity < ActiveRecord::Base
  belongs_to :deal, :dependent => :destroy
  attr_accessible :deal_id, :individual_contact_id, :is_converted, :opportunity
end
