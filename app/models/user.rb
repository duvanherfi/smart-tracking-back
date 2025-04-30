class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  has_secure_password

  field :name, type: String
  field :email, type: String
  field :phone, type: String
  field :password, type: String
  field :password_digest, type: String
  field :is_active, type: Mongoid::Boolean, default: true

  has_many :sessions
  has_many :vehicles
  has_many :geo_fences

  validates :email, presence: true
  validates :name, presence: true
  validates :phone, presence: true, uniqueness: true
end
