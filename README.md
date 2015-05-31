# TraxoApi

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'traxo_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install traxo_api

## Usage

### Authorization
Traxo's API uses the OAuth 2.0 standard for authorization. Additionally, Traxo enforces two later security additions: a _redirect URL_ and a _state parameter_.

To gain authorization from a Traxo user, you will need to [register your application](https://developer.traxo.com/signup) with Traxo.  Once registered, you will need to retrieve your your _client ID_ and _client secret_ from the API's website where you will also need to register a _redirect url_ for the application.

#### Authorization methods

##### ::new(client_id, client_secret, redirect_url) => Traxo::Auth
Initializes and returns a Traxo::Auth object. The three parameters are required to complete the the authorization process.

##### \#request_code_url(state) => String
Returns a String containing the URL for redirecting users to the Traxo API to authorize your application on their behalf.

When Traxo redirects back to your application from this URL, the redirect will include a 'request code' and the 'state parameter' string that you provided.

__Note__: While the Traxo API (and, in turn, this gem) requires the ['state parameter'](http://www.thread-safe.com/2014/05/the-correct-use-of-state-parameter-in.html) string to protect against CRSF attacks, it is ultimately the client's decision whether or not to check the returned state string against the state string provided to the API.

##### \#exchange_request_code(code) => Hash
Using an access code from the API, requests tokens from the Traxo API and returns the API's response as a Hash.  Response keys include 'access_token', 'expires_in', and 'refresh_token.'

__Note__: As of 5/15, user authorization lasts up to one year, but each access_token only lasts 24 hours (specified with the response's 'expires_in' value). If you have a stale access_token, you should either direct your user back to reauthorize or use the __\#exchange_refresh_token__ method below with the response's 'refresh_token' value.

##### \#exchange_refresh_token => Hash
Using a refresh token, requests new tokens from the Traxo API and returns the API's response as a Hash.  Response keys include 'access_token', 'expires_in', and 'refresh_token.'



#### Example of authorization controller flow
```
class TraxoController < ApplicationController

	def auth
	    t = Traxo::Auth.new('CLIENT_ID', 'CLIENT_SECRET', 'REDIRECT_URL')
	    state = 'SOME_STRING'
	    redirect_to t.request_code_url(state)
	end
	
	def auth_success
	    t = Traxo::Auth.new('CLIENT_ID', 'CLIENT_SECRET', 'REDIRECT_URL')
	    code = params[:code]
	    response = t.exchange_request_code(code)
	    
	    access_token = response['access_token'] # used to authorize requests
	    lifetime = response['expires_in'] # number of seconds until access_token expires (currently 24 hours)
	    refresh_token = response['refresh_token'] # used to request new tokens
	end
	
		# store tokens (and use elsewhere for CRUD requests)...
end

```


### CRUD

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/wilchandler/traxo_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
