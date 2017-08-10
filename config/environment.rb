# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
SalesCafe::Application.initialize!

#ENV['cloudfront'] = "http://d11oxq348wyj4g.cloudfront.net"
ENV['cloudfront'] = ""
ENV['andolaORG'] = "1"
ENV['mode'] = Rails.env
ENV['url'] = "http://localhost:3000/"
@@category = ["Skype", "GTalk", "Yahoo", "AOL", "Windows Live", "Digsby","Aim","MSN"]
