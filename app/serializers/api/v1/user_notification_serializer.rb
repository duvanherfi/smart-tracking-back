# frozen_string_literal: true

class Api::V1::UserNotificationSerializer < Oj::Serializer
  attributes :_id, :translate, :user_id, :server_time, :lat, :lon, :speed, :course, :external_device_id, :label_direction

  attribute
  def geo_fence
    user_notification.geo_fence&.name
  end

  attribute
  def plates
    user_notification.vehicle&.plates
  end

  attribute
  def type
    {
      "ignitionOff": "Apagado",
      "geofenceEnter": "Entrada Geocerca",
      "geofenceExit": "Salida Geocerca",
      "ignitionOn": "Encendido"
    }[user_notification.type.to_sym]
  end
end
