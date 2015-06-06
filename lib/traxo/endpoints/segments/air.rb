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

    def create_air_segment(args)
      url = "#{ API_URL}segments/air"
      data = create_air_segment_options(args)
      post_request_with_token(url, data)
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

    def create_air_segment_options(args)
      args = args.dup
      args[:departure_datetime] = convert_time args[:departure_datetime]
      args[:arrival_datetime] = convert_time args[:arrival_datetime]
      create_air_segment_required_params(args)
      options = [ :trip_id, :origin, :destination, :departure_datetime,
                  :arrival_datetime, :airline, :flight_num, :seat_assignment,
                  :confirmation_no, :number_of_pax, :price, :currency, :phone,
                  :first_name, :last_name ]
      args.keep_if { |key| options.include? key }
    end

    def create_air_segment_required_params(args)
      required = [:trip_id, :origin, :destination, :departure_datetime,
                  :arrival_datetime, :airline, :flight_num]
      required.each do |arg|
        raise ArgumentError.new("#{arg} is a required argument key") unless args[arg]
      end
    end
  end

end