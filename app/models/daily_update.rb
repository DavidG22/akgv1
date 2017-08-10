class DailyUpdate < ActiveRecord::Base
  belongs_to :deal
  attr_accessible :alert_time, :frequency, :time_zone, :user_ids, :deal_id
  #after_create :send_daily_update_mail
  
  def send_daily_update_mail
  	begin
  		puts "3333333333333333333"
  		Notificaiton.send_daily_updates(self.user_ids,self.deal).deliver
  	rescue Exception => e
  		puts "-------- error to send mail #{e.message}"
  	end
  end
end
