module Traxo

  class Auth

    OAUTH_URL = "https://www.traxo.com/oauth/"
    TOKEN_URL = "#{OAUTH_URL}token/"

    def initialize(client_id, client_secret)
      @client_id = client_id
      @client_secret = client_secret
    end

    def request_code_url(oauth_redirect_url, state='live')
      "#{OAUTH_URL}authenticate?client_id=#{@client_id}&response_type=code&redirect_uri=#{oauth_redirect_url}&state=#{state}"
    end
  end

end