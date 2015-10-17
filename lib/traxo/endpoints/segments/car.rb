module Traxo
  class Client
    def get_car_segments(args = {})
      query = get_car_segments_options(args)
      url = "#{ API_URL }segments/car#{ query_string(query) }"
      get_request_with_token(url)
    end

    def get_car_segment(id)
      url = "#{ API_URL}segments/car/#{id}"
      get_request_with_token(url)
    end

    def create_car_segment(args)
      url = "#{ API_URL}segments/car"
      data = create_car_segment_options(args)
      post_request_with_token(url, data)
    end

    def update_car_segment(id, args)
      url = "#{ API_URL}segments/car/#{id}"
      data = create_car_segment_options(args, false)
      data.delete_if { |key, val| !val } # previous datetime filtering is skipped
      raise ArgumentError.new('Must provide options to update segment') if data.empty?
      put_request_with_token(url, data)
    end

    def delete_car_segment(id)
        url = "#{ API_URL }segments/car/#{id}"
        delete_request_with_token(url)
    end

      private

    def get_car_segments_options(args)
      unless args.empty?
        args = args.dup
        options = [:status, :start, :end]
        args.select! { |key| options.include? key }
      end
      args = { start: 'today' }.merge(args)
      args[:start] = convert_time(args[:start]) unless args[:start] == 'today'
      if args[:end] && args[:end] != 'today'
        args[:end]= convert_time(args[:end])
      end
      args
    end

    def create_car_segment_options(args)
      #
    end

  end
end