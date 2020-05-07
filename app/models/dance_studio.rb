class DanceStudio < ApplicationRecord
  # adds methods, ie: dancers, dancers<<, dancers.delete, dancers_ids=ids
  has_many :dancers, dependent: :destroy # all associated objects also destroyed
  # adds methods, ie: costumes, costumes<<, costumes.delete, costumes_ids=ids
  has_many :costumes, dependent: :destroy
  # adds methods, ie: costume_assignment_ids=ids
  has_many :costume_assignments, through: :costumes
  has_many :costume_assignments, through: :dancers

  has_secure_password

  validate :email_not_taken, on: :create
  validate :email_not_taken, on: :update

  validates :password, confirmation: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :studio_name, :owner_name, :password_confirmation, presence: true

  def email_not_taken
    Dancer.all.each do |dancer|
      errors.add(:email, 'is taken') if dancer.email.downcase == email.downcase
    end
  end

  # Omniauth - google
  def self.from_omniauth(auth)
    # Creates a new user only if it doesn't exist
    where(email: auth.info.email).first_or_initialize do |user|
      user.owner_name = auth.info.name
      user.email = auth.info.email
    end
  end

  # Gets the current costume assignments for a dance studio
  def current_studio_assignments
    costume_assignments.where("dance_season = '%s'", Time.now.year)
  end

  # Gets the current costumes for a dance studio
  def current_studio_costumes
    Costume.find_by_assignment(current_studio_assignments)
  end

  # Gets the currently unassigned costumes for a dance studio
  def unassigned_studio_costumes
    costumes.to_a.delete_if { |costume| current_studio_costumes.include?(costume) }
  end
end
