require 'spec_helper'

describe Traxo::Trip do
  it { should have_attr_accessor(:id) }
  it { should have_attr_accessor(:member_id) }
  it { should have_attr_accessor(:itinerary_id) }
  it { should have_attr_accessor(:status) }
  it { should have_attr_accessor(:first_name) }
  it { should have_attr_accessor(:last_name) }
  it { should have_attr_accessor(:destination) }
  it { should have_attr_accessor(:lat) }
  it { should have_attr_accessor(:lon) }
  it { should have_attr_accessor(:state) }
  it { should have_attr_accessor(:postal_code) }
  it { should have_attr_accessor(:country) }
  it { should have_attr_accessor(:begin_datetime) }
  it { should have_attr_accessor(:begin_time_zone) }
  it { should have_attr_accessor(:begin_time_zone_id) }
  it { should have_attr_accessor(:end_datetime) }
  it { should have_attr_accessor(:end_time_zone) }
  it { should have_attr_accessor(:end_time_zone_id) }
  it { should have_attr_accessor(:privacy) }
  it { should have_attr_accessor(:personal) }
  it { should have_attr_accessor(:business) }
  it { should have_attr_accessor(:verified) }
  it { should have_attr_accessor(:distance) }
  it { should have_attr_accessor(:duration) }
  it { should have_attr_accessor(:headline) }
  it { should have_attr_accessor(:url) }
  it { should have_attr_accessor(:harvested) }
  it { should have_attr_accessor(:created) }
  it { should have_attr_accessor(:updated) }
  it { should have_attr_accessor(:segments) }
  it { should have_attr_accessor(:notes) }
end