module Traxo

  class Client
    def get_account(id)
      url = "#{ API_URL}accounts/#{id}"
      response = get_request_with_token(url)
      Account.new(response)
    end
  end

end