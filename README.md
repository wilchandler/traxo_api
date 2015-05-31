# traxo_api

The 'traxo_api' gem is a Ruby wrapper meant to simplify processes of authorizing applications and creating interactions with the [Traxo API](https://developer.traxo.com).

Contents:  
- [Installation](## Installation)  
- [Usage](## Usage)  
  - [Authorization](### Authorization)  
    - [Authorization methods](#### Authorization methods)  
    - [Example of controller flow](#### Example of authorization controller flow)  
  - [CRUD](### Crud)  
    - [Client Initialization](#### Client Initialization)  
    - [Trip Endpoints](### Trip Endpoints)  
- [Contributing](## Contributing)

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
	    lifetime = response['expires_in'] # seconds until access_token expires
	    refresh_token = response['refresh_token'] # used to request new tokens
	end
	
		# store tokens (and use elsewhere for CRUD requests)...
end

```


### CRUD
Once a user has authorized your application and you have a valid access token, you can start making CRUD (create, read, update, delete) requests to the Traxo API on their behalf.

#### Client Initialization

##### ::new(access_token, client_id, client_secret) => Traxo::Client
Returns a Traxo::Client object which provides the methods for interacting with the API.

```
t = Traxo::Client.new('ACCESS_TOKEN', 'CLIENT_ID', 'CLIENT_SECRET')
t.get_member # => Traxo::Member object
```

#### Member Endpoints
##### \#get_member => Traxo::Member
Returns a Traxo::Member object with the authorizing user's Traxo information.

##### \#get_stream(args = {}) => Array (from parsed JSON)
Returns the 'travel stream' for the authorizing user's Traxo account.  

Optional argument keys:  
_:offset_, _:limit_


#### Account Endpoints

##### \#get_account(id) => Traxo::Account
Returns a travel account with the provided ID as a Traxo::Acount object

##### \#get_acounts(args = {}) => Array (of Traxo::Account objects)
Returns an array of travel accounts (as Traxo::Account objects)

Optional argument keys:  
_:status_, _:classification_, _:offset_, _:limit_


#### Trip Endpoints

##### \#get_trips(args={})
Retrieves a collection of the user's trips matching the given parameters.  

Optional argument keys:  
- _:segments_  
- _:start_  
- _:end_  
- _:since_  
- _:until_  
- _:status_  
- _:privacy_  
- _:purpose_  
- _:count_  
- _:offset_  
- _:limit_  
- _:recursive_  

##### \#get_trip(id, args={})
Retrieves the user's trip with the given id.  

Optional argument keys:  
_:segments_ (boolean, include travel segments or not)

##### \#get_current_trip(args={})
Retrieves the trip that the user is currently taking.
 
_Optional argument keys same as \#get_trip_

##### \#get_upcoming_trips(args={})
Retrieves upcoming trips.

Optional argument keys:  
- _:segments_  
- _:privacy_  
- _:purpose_  
- _:limit_  
- _:offset_


##### \#get_past_trips(args={})
Retrieves past trips.

_Optional argument keys same as \#get_current_trip_

##### \#get_trip_oembed(id)
Retrieves the user's trip with the given id in the oEmbed format.

##### \#create_trip(args)
Creates a trip for the user from the given "args" Hash.

Required argument keys:  
- _:destination_ (String, i.e. 'Little Rock, AR, US')  
- _:start_datetime_    
- _:end_datetime_  

Optional argument keys:  
- _:personal_  
- _:business_  
- _:privacy_  
- _:headline_  
- _:first_name_  
- _:last_name_  


##### \#update_trip(id, args)
Updates the user's trip that has the given id to have the properties from the given "args" Hash.

_Optional argument keys include all of the required and optional keys of \#create_trip._

##### \#delete_trip(id)
Deletes the user's trip with the given ID.


#### Segment (air, car, rail, hotel, activity) Endpoints
_Not yet implemented_

#### Source Endpoints
_Not yet implemented_

#### Provider Endpoints
_Not yet implemented_

#### Location endpoints
_Not yet implemented_

#### Callback endpoints
_Not yet implemented_



## Contributing

1. Fork it ( https://github.com/wilchandler/traxo_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
