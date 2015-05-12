require 'spec_helper'

describe Traxo::Member do
  it { should have_attr_accessor(:id) }
  it { should have_attr_accessor(:first_name) }
  it { should have_attr_accessor(:last_name) }
  it { should have_attr_accessor(:email) }
  it { should have_attr_accessor(:gender) }
  it { should have_attr_accessor(:home_city) }
  it { should have_attr_accessor(:home_city_lon) }
  it { should have_attr_accessor(:home_city_lat) }
  it { should have_attr_accessor(:state_provence) }
  it { should have_attr_accessor(:zip) }
  it { should have_attr_accessor(:country) }
  it { should have_attr_accessor(:time_zone_id) }
  it { should have_attr_accessor(:traveL_score) }
  it { should have_attr_accessor(:url) }
  it { should have_attr_accessor(:profile_image_url) }
  it { should have_attr_accessor(:created) }
  it { should have_attr_accessor(:updated) }
end