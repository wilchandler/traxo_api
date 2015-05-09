module Traxo

  class Client
    attr_accessor :access_token

    API_URL = "https://api.traxo.com/v2/"

    def initialize(client_id, client_secret, access_token)
      @client_secret = client_secret
      @client_id = client_id
      @access_token = access_token
    end

      private

    def make_http_request(uri)
      Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == "https") do |http|
        yield(http, uri)
      end
    end

    def get_request_with_token(url)
      uri = URI.parse(url)
      request = Net::HTTP::Get.new(uri)
      request['Authorization'] = "Bearer #{@access_token}"
      response = make_http_request(uri) { |http| http.request(request) }
      JSON.parse(response.body)
    end

    def get_request_with_token_and_client(url)
      # TO BE IMPLEMENTED
      # Some endpoints require client id and secret (most do not)
    end

    def query_string(data = {})
      (data.empty?) ? '' : "?#{ URI.encode_www_form(data)}"
    end
  end
  
end