Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '187448291422507', '1cc29696449f87708eae7223dbe074e4', :scope => 'email', :display => 'popup'
  #provider :linkedin, "", ""
  #provider :google_oauth2, "", "", { access_type: "offline", approval_prompt: "" }
  #provider :twitter, '', ''
end