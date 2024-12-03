class Session
  include Mongoid::Document
  include Mongoid::Timestamps

  field :token, type: String
  field :is_enabled, type: Mongoid::Boolean, default: true

  belongs_to :user

  before_create :generate_token

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(40)
      break random_token unless self.class.where(token: random_token).exists?
    end
  end
end
