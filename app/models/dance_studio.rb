class DanceStudio < ApplicationRecord
  # adds methods, ie: dancers, dancers<<, dancers.delete, dancers_ids=ids
  has_many :dancers
  # adds methods, ie: costumes, costumes<<, costumes.delete, costumes_ids=ids
  has_many :costumes
  # adds methods, ie: costume_assignment_ids=ids
  has_many :costume_assignments, through: :costumes
  has_many :costume_assignments, through: :dancers
  # adds methods
  accepts_nested_attributes_for :costumes, :costume_assignments

  has_secure_password

  validates :password, confirmation: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :studio_name, :owner_name, :password_confirmation, presence: true
  # Gets current costumes for a dance studio
  scope :current_studio_costumes, lambda { |studio| Costume.find_by_assignment(studio.costume_assignments.where("dance_season = '%s'", Time.now.year)) }
  
  def self.from_omniauth(auth)
    # Creates a new user only if it doesn't exist
    where(email: auth.info.email).first_or_initialize do |user|
      user.owner_name = auth.info.name
      user.email = auth.info.email
    end
  end
  # Gets current costume assignments for a dance studio
  def current_studio_assignments
    costume_assignments.where("dance_season = '%s'", Time.now.year)
  end
  # Gets current costumes for a dance studio
  def current_studio_costumes
    Costume.find_by_assignment(costume_assignments.where("dance_season = '%s'", Time.now.year))
  end
end
