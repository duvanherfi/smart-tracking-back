# frozen_string_literal: true

class GpsecService
  include HTTParty

  base_uri 'http://gpsec.datanetcenter.com:1909'


  def get_positions(device_id, start_at, end_at, token)
    path = "/api/v1/positionsBetweenDates"
    response = self.class.get(
      path, query: { deviceId: device_id, startPositionDate: start_at, endPositionDate: end_at },
      headers: { 'Authorization': "Bearer #{token}"}
    )

    JSON.parse(response.body)
  end
end
