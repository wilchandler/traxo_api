module Traxo
  class Client

    def get_trips(options = {})
      data = get_trips_options(options)
      url = "#{ API_URL }trips#{ query_string(data) }"
      get_request_with_token(url)
    end

    def get_trip(trip_id, options = {})
      data = get_trip_options(options)
      url = "#{ API_URL }trips/#{ trip_id }#{ query_string(data) }"
      get_request_with_token(url)
    end

    def get_current_trip(options = {})
      data = get_trip_options(options)
      url = "#{ API_URL }trips/current#{ query_string(data) }"
      get_request_with_token(url)
    end

    def get_upcoming_trips(options = {})
      data = get_past_or_upcoming_trips_options(options)
      url = "#{ API_URL }trips/upcoming#{ query_string(data) }"
      get_request_with_token(url)
    end

    def get_past_trips(options = {})
      data = get_past_or_upcoming_trips_options(options)
      url = "#{ API_URL }trips/past#{ query_string(data) }"
      get_request_with_token(url)
    end

    def get_trip_oembed(trip_id)
      url = "#{ API_URL }trips/oembed/#{trip_id}"
      get_request_with_token(url)
    end

    def create_trip(arg)
      data = create_trip_data(arg)
      create_trip_check_required_params(data)
      url = "#{ API_URL}trips"
      post_request_with_token(url, data)
    end

    def update_trip(trip_id, args)
      raise ArgumentError.new('Must provide an integer trip ID') unless trip_id.is_a?(Fixnum)
      raise ArgumentError.new('Must provide a Hash of attributes') unless args.is_a? Hash
      return false if args.empty?
      data = create_trip_data_from_hash(args)
      url = "#{ API_URL }trips/#{ trip_id }"
      put_request_with_token(url, data)
    end

    def delete_trip(trip_id)
      raise ArgumentError.new('Must provide an integer trip ID') unless trip_id.is_a?(Fixnum)
      url = "#{ API_URL }trips/#{ trip_id }"
      delete_request_with_token(url)
    end

      private

    def get_trips_options(args)
      # not implemented: count (via X-Total-Count header)
      # until: Filter results changed until this UTC date/time (ISO8601)
      # since: Filter results changed since this UTC date/time (ISO8601)
      # recursive: Include changed sub-objects (requires: since or until)
      # start: listed as defaulting to "today" on Traxo API Explorer (as of 5/12/15)

      unless args.empty?
        options = [:segments, :start, :end, :since, :until, :status, :privacy,
                   :purpose, :count, :offset, :limit, :recursive]
        args.select! { |a| options.include? a }
        args.delete(:recursive) unless (args[:since] || args[:until])
      end
      args[:segments] = 1 if args[:segments]
      args[:recursive] = 1 if args[:recursive]
      {start: 'today'}.merge(args)
    end

    def get_trip_options(args)
      ([1, true].include? args[:segments]) ? { segments: 1 } : {}
    end

    def get_past_or_upcoming_trips_options(args)
      args[:segments] = 1 if [true, 1, '1'].include? args[:segments]
      options = [:segments, :privacy, :purpose, :limit, :offset]
      args.select! { |a| options.include? a }
      args
    end

    def create_trip_data(arg)
      if arg.is_a? Hash
        create_trip_data_from_hash(arg)
      else
        raise ArgumentError.new('Argument must be a Hash')
      end
    end

    def create_trip_data_from_hash(arg)
      options = [:destination, :begin_datetime, :end_datetime, :personal,
                 :business, :privacy, :headline, :first_name, :last_name]
      arg.select! { |a| options.include? a }

      negative = [false, -1, 0, 'no', 'No', 'n', 'N']
      (arg[:business] = negative.include?(arg[:business]) ? 'N' : 'Y') if arg[:business]
      (arg[:business] = negative.include?(arg[:business]) ? 'N' : 'Y') if arg[:personal]
      arg[:begin_datetime] = convert_time(arg[:begin_datetime]) if arg[:begin_datetime]
      arg[:end_datetime] = convert_time(arg[:end_datetime]) if arg[:end_datetime]
      arg
    end

    def create_trip_check_required_params(arg)
      if arg.is_a? Hash
        valid = arg[:destination] && arg[:end_datetime] && arg[:begin_datetime]
      end
      unless valid
        message = 'Argument must include destination, end_datetime, and begin_datetime'
        raise ArgumentError.new(message)
      end
    end

  end
end
