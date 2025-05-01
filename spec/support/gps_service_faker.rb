require 'sinatra/base'

class GpsServiceFaker < Sinatra::Base

  post '/api/v1/login' do
    json_response(200, 'gps_service_login.json')
  end

  get '/api/v1/validateSesion' do
    {
      "statusCode": 200,
      "message": "Success",
      "data": true
    }.to_json
  end

  get '/api/v1/reports/summary' do
    json_response(200, 'gps_service_summary.json')
  end

  get '/api/v1/devices' do
    json_response(200, 'gps_service_devices.json')
  end

  get '/api/v1/positionsBetweenDates' do
    json_response(200, 'gps_service_positions.json')
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