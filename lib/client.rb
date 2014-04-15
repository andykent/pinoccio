module Pinoccio
  class Client
    attr_reader :token

    def initialize(email_or_token, password=nil)
      @connection = Faraday.new(:url => 'https://api.pinocc.io/')
      if password.nil?
        @token = email_or_token
      else
        login(email_or_token, password)
      end
    end

    def login(email, password)
      response = post("login", email: email, password: password)
      @token = response.token
    end

    def account
      get "account"
    end

    def troops
      TroopCollection.new(self)
    end

    def get(path, data={})
      data = {token:@token}.merge(data) if @token
      response = @connection.get("/v1/#{path}", data)
      handle_response(response)
    end

    def post(path, data={})
      data = {token:@token}.merge(data) if @token
      response = @connection.post("/v1/#{path}", data)
      handle_response(response)
    end

    private

    def handle_response(response)
      hsh = JSON.parse(response.body)
      handle_error(hsh['error']) if hsh['error']
      data = hsh['data']
      if data.is_a? Array
        data.map {|d| OpenStruct.new(d) }
      else
        OpenStruct.new(data)
      end
    end

    def handle_error(err)
      if err['message'] && (err['message'] =~ /timeout/ || err['message'] =~ /timed out/)
        raise Pinoccio::TimeoutError.new(err)
      else
        raise Pinoccio::Error.new(err)
      end
    end
  end
end