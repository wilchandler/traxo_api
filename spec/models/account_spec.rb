require 'spec_helper'

describe Traxo::Account do

  it { should have_attr_reader(:id) }
  it { should have_attr_reader(:member_id) }
  it { should have_attr_reader(:status) }
  it { should have_attr_reader(:name) }
  it { should have_attr_reader(:program_name) }
  it { should have_attr_reader(:classification) }
  it { should have_attr_reader(:home_page_url) }
  it { should have_attr_reader(:password_url) }
  it { should have_attr_reader(:membership_url) }
  it { should have_attr_reader(:contact_url) }
  it { should have_attr_reader(:phone) }
  it { should have_attr_reader(:account_id) }
  it { should have_attr_reader(:last_access) }
  it { should have_attr_reader(:last_harvest_status) }
  it { should have_attr_reader(:image_url) }
  it { should have_attr_reader(:icon_image_url) }
  it { should have_attr_reader(:loyalty_status) }
  it { should have_attr_reader(:loyalty_level) }
  it { should have_attr_reader(:loyalty_points) }
  it { should have_attr_reader(:loyalty_image_url) }
  it { should have_attr_reader(:auto_login) }

end