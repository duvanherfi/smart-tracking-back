class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  has_secure_password
  has_secure_password :recovery_password, validations: false

  field :name, type: String
  field :email, type: String
  field :phone, type: String
  field :password, type: String
  field :password_digest, type: String
  field :recovery_password, type: String
  field :recovery_password_digest, type: String
  field :is_active, type: Mongoid::Boolean, default: true

  has_many :sessions
  has_many :vehicles
  has_many :geo_fences
  has_many :notifications, inverse_of: :user
  has_many :user_notifications, inverse_of: :user

  validates :email, presence: true
  validates :name, presence: true
  validates :phone, presence: true, uniqueness: true

  def send_email_recovery
    self.recovery_password = SecureRandom.hex(10) # Generate a random recovery password
    save

    ActionMailer::Base.mail(
      to: email,
      from: "info@#{ENV.fetch("MAILGUN_SMTP_DOMAIN", "smartracking.xyz")}",
      subject: "Tu código para recuperar tu contraseña",
      body: "Tu contraseña de recuperación para SmarTracking es: #{recovery_password}"
    ).deliver_now
  end
end
