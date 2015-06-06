module Traxo

  class Client
    def get_air_segments(args = {})
      query = get_air_segments_options(args)
      url = "#{API_URL}segments/air#{ query_string(query) }"
      get_request_with_token(url)
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
      url = "#{ API_URL}segments/air/#{id}"
      delete_request_with_token(url)
    end

      private

    def get_air_segments_options(args)
      unless args.empty?
        args = args.dup
        options = [:start, :status, :end]
        args.select! { |key| options.include? key }
      end
      args = {start: 'today'}.merge(args)
      args[:start] = convert_time(args[:start]) unless args[:start] == 'today'
      if args[:end] && args[:end] != 'today'
        args[:end] = convert_time(args[:end])
      end
      args
    end
  end

end