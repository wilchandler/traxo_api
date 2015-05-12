module Traxo
  class Client

    def get_trips(options = {})
      data = get_trips_options(options)
      url = "#{ API_URL }trips#{ query_string(data) }"
      response = get_request_with_token(url)
      response.map { |trip_params| Trip.new(trip_params) }
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

  end
end