namespace :auth_token do  
    #Update auth_token where auth_token is nil
    task :update_auth_token => :environment do 
        organizations = Organization.where(auth_token: nil)
        puts organizations
        organizations.each do |org|
            auth_key = "#{org.id}-#{org.name}-#{org.created_at.strftime('%Y-%m-%d %H:%M:%S')}"
            org.update_attributes!(auth_token: Base64::encode64(auth_key))
        end
    end
end