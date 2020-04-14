class Dancer < ApplicationRecord
  belongs_to :dance_studio
  has_many :costume_assignments
  has_many :costumes, through: :costume_assignments

  has_secure_password

  validates :password, confirmation: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :first_name, :last_name, :password_confirmation, presence: true

  # Gets current dancers for a dance studio
  scope :current_dancers, lambda { |studio| where(["dance_studio_id = '%s' and current_dancer = '%s'", studio.id, 1]) }

  # OmniAuth - Google
  def self.from_omniauth(auth)
    # Creates a new user only if it doesn't exist
    where(email: auth.info.email).first_or_initialize do |user|
      user.email = auth.info.email
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
    end
  end

  # Concatenates a dancer's first and last name
  def name
    first_name + ' ' + last_name
  end
end
