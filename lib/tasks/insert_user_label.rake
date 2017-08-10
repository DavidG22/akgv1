namespace :wus do
  task :insert_user_label => :environment do 
    UserLabel.create(name: "Uncategorised")
    UserLabel.create(name: "Inbound")
    UserLabel.create(name: "Outbound")
    p "User label insrted successfully.!!"
  end
end