#traxo_api

The 'traxo_api' gem is a Ruby wrapper meant to simplify processes of authorizing applications and creating interactions with the [Traxo API](https://developer.traxo.com).

###README Contents:  
- [Installation](#toc-installation)  
- [Usage](#toc-usage)  
  - [Authorization](#toc-auth)  
  - [CRUD](#toc-crud)  
- [Documentation](#toc-docs)
- [License](#toc-license)
- [Contributing](#toc-contributing)

<a name="toc-installation"></a>
##Installation

Add this line to your application's Gemfile:

```ruby
gem 'traxo_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install traxo_api

<a name="toc-usage"></a>
##Usage

<a name="toc-auth"></a>
###Authorization
Traxo's API uses the OAuth 2.0 standard for authorization. Additionally, Traxo enforces two later security additions: a _redirect URL_ and a _state parameter_.

To gain authorization from a Traxo user, you will need to [register your application](https://developer.traxo.com/signup) with Traxo.  Once registered, you will need to retrieve your your _client ID_ and _client secret_ from the API's website where you will also need to register a _redirect url_ for the application.

####Example of authorization controller flow
```ruby
class TraxoController < ApplicationController

	def auth
	    t = Traxo::Auth.new('CLIENT_ID', 'CLIENT_SECRET', 'REDIRECT_URL')
	    state = 'SOME_STRING'
	    redirect_to t.request_code_url(state)
	end
	
	def auth_success
	    t = Traxo::Auth.new('CLIENT_ID', 'CLIENT_SECRET', 'REDIRECT_URL')
	    
	    # this conditional is not required, but uses CSRF protection made possible 
	    # by Traxo's enforcement of a state parameter in authorization requests
	    if params[:state] == 'SOME_STRING'
	      code = params[:code]
	      response = t.exchange_request_code(code)
	    
	      access_token = response['access_token'] # used to authorize requests
	      lifetime = response['expires_in'] # seconds until access_token expires
	      refresh_token = response['refresh_token'] # used to request new tokens
	      
	      # store tokens (and use elsewhere for CRUD requests)...
	    end
	end
	
	
end

```

<a name="toc-crud"></a>
###CRUD
Once a user has authorized your application and you have a valid access token, you can start making CRUD (create, read, update, delete) requests to the Traxo API on their behalf.

```ruby
t = Traxo::Client.new('ACCESS_TOKEN', 'CLIENT_ID', 'CLIENT_SECRET')
t.get_member # => Hash of properties for user's Traxo account

args = {
  begin_datetime = '2015-06-01', 
  end_datetime: '2015-06-08', 
  destination: 'Little Rock, AR'
  headline: 'Good times in the Rock',
  personal: true
}
t.create_trip(args) # => Hash of properties for a freshly created Trip
```

<a name="toc-docs"></a>
## Documentation
[View the documentation](https://github.com/wilchandler/traxo_api/wiki)  
Covers more in-depth usage and the public methods available within this gem.

<a name="toc-license"></a>
##License
[View MIT License](LICENSE.txt)

<a name="toc-contributing"></a>
##Contributing

1. Fork it ( https://github.com/wilchandler/traxo_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
