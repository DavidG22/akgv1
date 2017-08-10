class LatestBlogNotification
  include Sidekiq::Worker
  
  def perform(guid,title,content,send_all)   
  end
end