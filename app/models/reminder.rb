class Reminder < ActiveRecord::Base
  belongs_to :reminder_type
  belongs_to :deal
  attr_accessible :description, :email_ids, :reminder_date, :send_before, :sent_at, :title, :deal_id, :reminder_type_id, :deal, :reminder_type
  after_create :send_reminder_notification

  def send_reminder_notification
	  begin
	 	Notification.send_reminder_email(self)	
	  rescue Exception => e
	  	puts "---------- Error sending remindre notification: #{e.message}"
	  end
  end
end
