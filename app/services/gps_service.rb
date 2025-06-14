# frozen_string_literal: true

class GpsService
  include HTTParty

  base_uri "#{ENV.fetch("GPS_SERVICE")}"

  STAR_AT ||= Time.now.in_time_zone("Bogota").beginning_of_year.utc.strftime("%FT%RZ")
  END_AT ||= Time.now.in_time_zone("Bogota").utc.strftime("%FT%RZ")

  headers 'Content-Type': "application/json"

  attr_accessor :token, :login_response, :validate_session_response, :devices_response, :summary_response,
                :notification_response

  def initialize
    self.token = Redis::Value.new("GPS_TOKEN").value
  end

  def get_positions(device_id = "", start_at = STAR_AT, end_at = END_AT)
    path = "/api/v1/positionsBetweenDates"
    self.class.get(
      path,
      query: { deviceId: device_id, startPositionDate: start_at, endPositionDate: end_at },
      headers: { 'Authorization': "Bearer #{self.token}" }
    ).parsed_response
  end

  def devices
    path = "/api/v1/devices"
    self.devices_response ||= self.class.get(
      path,
      headers: { 'Authorization': "Bearer #{self.token}" }
    )
  end

  def notifications
    path = "/api/v1/notifications"
    self.notification_response ||= self.class.get(
      path,
      headers: { 'Authorization': "Bearer #{self.token}" }
    )
  end

  def summary(device_id = "", start_at = STAR_AT, end_at = END_AT)
    path = "/api/v1/reports/summary"
    self.summary_response ||= self.class.get(
      path,
      query: { deviceId: device_id, from: start_at, to: end_at },
      headers: { 'Authorization': "Bearer #{self.token}" }
    ).parsed_response
    self.summary_response = nil if self.summary_response["statusCode"] == 500
    self.summary_response
  end

  def validate_session
    return if Redis::Value.new("GPS_TOKEN").value

    path = "/api/v1/validateSesion"
    response = self.validate_session_response ||= self.class.get(
      path,
      body: { phone: ENV.fetch("GPS_USER").to_i, password: ENV.fetch("GPS_PASSWORD").to_i }.to_json,
      headers: { 'Authorization': "Bearer #{self.token}" }
    ).parsed_response
    Redis::Value.new("GPS_TOKEN").value = self.token
    response
  end

  def login
    return if self.token

    path = "/api/v1/login"
    self.login_response ||= self.class.post(
      path, body: { phone: ENV.fetch("GPS_USER").to_i, password: ENV.fetch("GPS_PASSWORD").to_i }.to_json
    ).parsed_response

    self.token = self.login_response["data"]["Token"]
    validate_session

    login_response
  end
end
