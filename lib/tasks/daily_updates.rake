namespace :wus do
  task :daily_updates => :environment do 
  	day = Date.today.strftime("%b")
    daily_update = DailyUpdate.where("frequency like (?)", "%"+ day+"%")
    puts "--------- daily update"
    p daily_update
    if daily_update.present?
	    daily_update.each do |du|
	    	puts "time match -------------"
	    	if Time.zone.now.strftime("%M:%M:%S") == du.alert_time.strftime("%H:%M:%S")
	    		#Notificaiton.send_daily_updates(du.user_ids,du.deal)
	    	end
    	end
    end
  end
end