require 'spec_helper'

describe Traxo::TripOEmbed do

  it { should have_attr_reader(:type) }  
  it { should have_attr_reader(:version) }  
  it { should have_attr_reader(:title) }  
  it { should have_attr_reader(:provider_name) }  
  it { should have_attr_reader(:provider_url) }  
  it { should have_attr_reader(:cache_age) }  
  it { should have_attr_reader(:url) }  
  it { should have_attr_reader(:scope) }  
  it { should have_attr_reader(:expires) }  

end