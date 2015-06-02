module Traxo

  class Client
    def get_account(id)
      url = "#{ API_URL}accounts/#{id}"
      get_request_with_token(url)
    end

    def get_accounts(options = {})
      data = get_accounts_options(options)
      url = "#{ API_URL}accounts#{ query_string(data) }"
      get_request_with_token(url)
    end

      private

    def get_accounts_options(args)
      options = [:status, :classification, :offset, :limit]
      args.select! { |a| options.include? a }
      args
    end
  end

end