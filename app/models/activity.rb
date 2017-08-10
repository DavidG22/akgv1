class Activity < ActiveRecord::Base

  attr_accessible :activity_type, :activity_id, :activity_user_id, :activity_status, :activity_desc, 
  :activity_date, :is_public, :organization_id, :source_id, :activity_by


  scope :by_range, lambda{ |start_date, end_date| where(:activity_date => start_date..end_date) }

  #has_many :users, :class_name=>"User" ,:foreign_key=>"activity_user_id"
  belongs_to :user, :class_name=>"User" ,:foreign_key=>"activity_user_id"
  has_many :deals, :class_name=>"Deal" ,:foreign_key=>"source_id"
  has_many :activities_contacts
  has_many :sent_email_opens

  ### Export CSV ###
  def self.to_csv
    CSV.generate do |csv|
      csv << ["Type", "Description", "Created On", "Created By", "Status"] ## Header values of CSV
      all.each do |activity|
        csv << [activity.activity_type, 
                activity.activity_desc,
                activity.created_at,
                activity.user.present? ? activity.user.full_name : "NA",
                activity.activity_status ] ##Row values of CSV
      end
    end
  end

end
