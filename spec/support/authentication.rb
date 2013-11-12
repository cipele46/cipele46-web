module AuthenticationHelper
  USERNAME = "pero@cipele46.org"
  PASSWORD = "cipelicelutalice"

  def encode_credentials(opts = {})
    "Basic #{Base64.encode64("#{opts[:username]}:#{opts[:password]}")}" 
  end

  def valid_credentials
    encode_credentials(:username => USERNAME, :password => PASSWORD) 
  end
end
