module Traxo

  class Client
    def get_member
      url = "#{ API_URL }me"
      json_response = get_request_with_token(url)
      Member.new(json_response)
    end

    def get_stream(args = {})
      args.select! { |key| [:offset, :limit, :count].include? key }
      url = "#{ API_URL }stream#{ query_string(args) }"
      get_request_with_token(url)
    end
  end

end