module Api
  def json_response
    JSON.parse(response.body)
  end

  def auth_api_headers(user)
    {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{user.auth_token}"
    }
  end
end

RSpec.configure do |config|
  config.include Api, type: :request
  config.include Api, type: :controller
end
