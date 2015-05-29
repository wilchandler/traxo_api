module Traxo
  class Client

    def get_trips(options = {})
      data = get_trips_options(options)
      url = "#{ API_URL }trips#{ query_string(data) }"
      response = get_request_with_token(url)
      response.map { |trip_params| Trip.new(trip_params) }
    end

    def get_trip(trip_id, options = {})
      data = get_trip_options(options)
      url = "#{ API_URL }trips/#{ trip_id }#{ query_string(data) }"
      response = get_request_with_token(url)
      Trip.new(response)
    end

    def get_current_trip(options = {})
      data = get_trip_options(options)
      url = "#{ API_URL }trips/current#{ query_string(data) }"
      response = get_request_with_token(url)
      Trip.new(response)
    end

    def get_upcoming_trips(options = {})
      data = get_past_or_upcoming_trips_options(options)
      url = "#{ API_URL }trips/upcoming#{ query_string(data) }"
      response = get_request_with_token(url)
      response.map { |trip| Trip.new(trip) }
    end

    def get_past_trips(options = {})
      data = get_past_or_upcoming_trips_options(options)
      url = "#{ API_URL }trips/past#{ query_string(data) }"
      response = get_request_with_token(url)
      response.map { |trip| Trip.new(trip) }
    end

    def get_trip_oembed(trip_id)
      url = "#{ API_URL }trips/oembed/#{trip_id}"
      response = get_request_with_token(url)
      TripOEmbed.new(response)
    end

    def create_trip(arg)
      data = create_trip_data(arg)
      url = "#{ API_URL}trips"
      response = post_request_with_token(url, data)
      Trip.new(response) if response
    end

    def delete_trip(id)
      raise ArgumentError.new('Must provide an integer trip ID') unless (id && id.is_a?(Fixnum))
      url = "#{ API_URL }trips/#{ id }"
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
      elsif arg.is_a? Trip
        create_trip_data_from_trip(arg)
      else
        raise ArgumentError.new('Argument must be a Traxo::Trip object or Hash')
      end
    end

    def create_trip_data_from_hash(arg)
      create_trip_check_required_params(arg)
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
      elsif arg.is_a? Trip
        #
      end
      unless valid
        message = 'Argument must include destination, end_datetime, and begin_datetime'
        raise ArgumentError.new(message)
      end
    end

  end
end
