module Traxo
  class TripOEmbed
    attr_reader :type, :version, :title, :provider_name, :provider_url,
                :cache_age, :url, :scope, :expires

    def initialize(args = {})
      args = Hash[args.map{ |k,v| [k.to_sym, v] }]

      @type =          args[:type]
      @version =       args[:version]
      @title =         args[:title]
      @provider_name = args[:provider_name]
      @provider_url =  args[:provider_url]
      @cache_age =     args[:cache_age]
      @url =           args[:url]
      @scope =         args[:scope]
      @expires =       args[:expires]
    end

  end
end