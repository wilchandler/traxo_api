module Traxo

  class Member < BaseModel

    ATTRIBUTES = [
      :id, :status, :first_name, :last_name, :email, :gender,
      :home_city, :home_city_lon, :home_city_lat, :state_provence,
      :zip, :country, :time_zone_id, :traveL_score, :url,
      :profile_image_url, :created, :updated
    ]

    ATTRIBUTES.each { |attr| class_eval { attr_accessor "#{attr}" } }

    def initialize(args = {})
      super(args, ATTRIBUTES)
    end

  end

end