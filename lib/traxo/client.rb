module Traxo

  class Client
    attr_accessor :access_token
    attr_reader :response_format, :error_handling

    API_URL = "https://api.traxo.com/v2/"

    def initialize(access_token, client_id, client_secret, options = {})
      @access_token = access_token
      @client_secret = client_secret
      @client_id = client_id
      assign_options(options)
    end

    def return_body!
      @response_format = :body
      self
    end

    def return_body_string!
      @response_format = :body_string
      self
    end

    def return_headers!
      @response_format = :headers
      self
    end

    def return_headers_string!
      @response_format = :headers_string
      self
    end

    def return_code!
      @response_format = :code
      self
    end

    def return_http_object!
      @response_format = :http
      self
    end

    def ignore_http_errors!
      @error_handling = :ignore
      self
    end

    def raise_http_errors!
      @error_handling = :raise
      self
    end

    def return_false_if_http_errors!
      @error_handling = :bool
      self
    end

      private

    def assign_options(options)
      assign_response_format(options[:response_format])
      assign_error_handling(options[:errors])
    end

    def assign_response_format(format)
      if format
        accepted = [:body, :body_string, :headers, :headers_string, :code, :http]
        if accepted.include? format
          @response_format = format
        else
          str = accepted.join(', :').insert(0, ':')
          raise ArgumentError.new(":response_format must be one of the following: #{str}")
        end
      else
        return_body!
      end
    end

    def assign_error_handling(action)
      if action
        if [:raise, :ignore, :bool].include? action
          raise_http_errors! if action == :raise
          ignore_http_errors! if action == :ignore
          return_false_if_http_errors! if action == :bool
        else
          raise ArgumentError.new(':errors parameter must be either :raise or :ignore')
        end
      else
        ignore_http_errors!
      end
    end

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
      format_response(response)
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
      format_response(response)
    end

    def put_request_with_token(url, data)
      uri = URI.parse(url)
      request = Net::HTTP::Put.new(uri)
      attach_token(request)
      attach_data(request, data)
      response = make_http_request(uri) { |http| http.request(request) }
      format_response(response)
    end

    def delete_request_with_token(url)
      uri = URI.parse(url)
      request = Net::HTTP::Delete.new(uri)
      attach_token(request)
      response = make_http_request(uri) { |http| http.request(request) }
      format_response(response)
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

    def format_response(response)
      return false unless check_success(response)

      case @response_format
      when :http
        response
      when :body
        body = response.body
        body.to_s.empty? ? {} : JSON.parse(body, symbolize_names: true)
      when :body_string
        response.body
      when :headers
        headers = {}
        response.header.each { |key| headers[key.to_sym] = response[key] }
        headers
      when :headers_string
        headers = {}
        response.header.each { |key| headers[key.to_sym] = response[key] }
        headers.to_json
      when :code
        response.code.to_i
      end
    end

    def check_success(response)
      if @error_handling == :raise
        return response.value || response
      elsif @error_handling == :ignore
        return response
      end
      response.code <= '300'
    end
  end
  
end