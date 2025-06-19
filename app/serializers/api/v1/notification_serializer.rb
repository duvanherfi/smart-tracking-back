# frozen_string_literal: true

class Api::V1::NotificationSerializer < Oj::Serializer
  attributes :_id, :is_enabled, :user_id

  attribute
  def name
    I18n.t("models.notification.names.#{notification.name}")
  end
end
