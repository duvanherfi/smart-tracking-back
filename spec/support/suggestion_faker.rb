require 'sinatra/base'

class SuggestionFaker < Sinatra::Base
  get '/api/v1/reverse' do
    json_response(200, 'suggestions_reverse.json')
  end


  private

  def json_response(response_code, fixtures_file_name)
    content_type :json
    status response_code

    File.open(
      File.dirname(__FILE__) + '/fixtures/' + fixtures_file_name, 'rb'
    ).read
  end
end
