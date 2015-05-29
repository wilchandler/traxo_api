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
      attach_token(request)
      response = make_http_request(uri) { |http| http.request(request) }
      response.code.to_i < 300 ? JSON.parse(response.body) : nil
    end

    def get_request_with_token_and_client(url)
      # TO BE IMPLEMENTED
      # Some endpoints require client id and secret (most do not)
    end

    def post_request_with_token(url, data)
      uri = URI.parse(url)
      request = Net::HTTP::Post.new(uri)
      attach_token(request)
      attach_data(request, data)
      response = make_http_request(uri) { |http| http.request(request) }
      response.code.to_i < 300 ? JSON.parse(response.body) : nil
    end

    def delete_request_with_token(url)
      uri = URI.parse(url)
      request = Net::HTTP::Delete.new(uri)
      attach_token(request)
      response = make_http_request(uri) { |http| http.request(request) }
      response.code.to_i < 300 ? true : false
    end

    def query_string(data = {})
      data.keep_if { |key, value| value }
      (data.empty?) ? '' : "?#{ URI.encode_www_form(data)}"
    end

    def attach_token(request)
      request['Authorization'] = "Bearer #{@access_token}"
    end

    def attach_data(request, data)
      request.set_form_data(data)
    end

    def convert_time(time)
      if time.is_a? String
        begin
          time = Time.parse(time)
        rescue
          return nil
        end
      elsif !(time.is_a?(Date) || time.is_a?(Time))
        return nil
      end
      time.iso8601
    end
  end
  
end