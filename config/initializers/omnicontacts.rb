#check https://github.com/Diego81/omnicontacts for more info

require "omnicontacts"

Rails.application.middleware.use OmniContacts::Builder do
  importer :gmail, "xxxxx", "xxxxxx", {:redirect_path => "/contacts/gmail/contact_callback"}

end


