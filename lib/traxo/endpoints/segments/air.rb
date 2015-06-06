module Traxo

  class Client
    def get_air_segments(args = {})
    end

    def get_air_segment(id)
      url = "#{ API_URL}segments/air/#{id}"
      get_request_with_token(url)
    end

    def create_air_segment(args = {})
    end

    def update_air_segment(id, args = {})
    end

    def delete_air_segment(id)
    end
  end

end