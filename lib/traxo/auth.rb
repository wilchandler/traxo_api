module Traxo

  class Auth

    OAUTH_URL = "https://www.traxo.com/oauth/"
    TOKEN_URL = "#{OAUTH_URL}token/"

    def initialize(client_id, client_secret, oauth_redirect_url)
      @client_id = client_id
      @client_secret = client_secret
      @oauth_redirect_url = oauth_redirect_url
    end

    def request_code_url(state)
      check_state_parameter(state)
      "#{OAUTH_URL}authenticate?client_id=#{@client_id}&response_type=code&redirect_uri=#{@oauth_redirect_url}&state=#{state}"
    end

    def exchange_request_code(code)
      data = token_request_data(code, @oauth_redirect_url)
      response = Net::HTTP.post_form(token_uri, data)
      JSON.parse(response.body, symbolize_names: true)
    end

    def exchange_refresh_token(token)
      data = token_refresh_data(token)
      response = Net::HTTP.post_form(token_uri, data)
      JSON.parse(response.body, symbolize_names: true)
    end

      private

    def token_uri
      URI.parse TOKEN_URL
    end

    def token_request_data(code, oauth_redirect_url)
      {
        client_id: @client_id,
        client_secret: @client_secret,
        grant_type: 'authorization_code',
        redirect_uri: @oauth_redirect_url,
        code: code
      }
    end

    def token_refresh_data(token)
      {
        client_id: @client_id,
        client_secret: @client_secret,
        grant_type: 'refresh_token',
        refresh_token: token
      }
    end

    def check_state_parameter(state)
      if !state.is_a?(String) || state.empty? 
        raise ArgumentError.new('State parameter must be a (non-empty) string')
      end
    end
  end

end