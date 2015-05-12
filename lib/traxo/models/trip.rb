module Traxo
  class Trip < BaseModel

  ATTRIBUTES = [
    :id, :member_id, :itinerary_id, :status, :first_name, :last_name,
    :destination, :lat, :lon, :state, :postal_code, :country, :begin_datetime,
    :begin_time_zone, :begin_time_zone_id, :end_datetime, :end_time_zone,
    :end_time_zone_id, :privacy, :personal, :business, :verified, :distance,
    :duration, :headline, :url, :harvested, :created, :updated, :segments,
    :notes
  ]

  ATTRIBUTES.each { |attr| class_eval { attr_accessor "#{attr}" } }


    def initialize(args = {})
      args['segments'] = [] unless args[:segments].class == Array
      args['notes'] = [] unless args[:notes].class == Array
      super(args, ATTRIBUTES)
    end
  end
end