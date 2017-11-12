class User < ApplicationRecord
  has_secure_password

  ROLES = %w[admin agent customer].freeze

  scope :admins, -> { where(role: ROLES.index('admin')) }
  scope :agents, -> { where(role: ROLES.index('agent')) }
  scope :customers, -> { where(role: ROLES.index('customer')) }

  validates :email, presence: true, uniqueness: true
  validates :name, :role, presence: true

  ROLES.each do |role_name|
    define_method("#{role_name}?") { role == ROLES.index(role_name) }
  end

  def load_token
    return token if token.present?
    new_token = SecureRandom.uuid.delete('-')
    update_columns(token: new_token)
    new_token
  end

  def role_name
    ROLES[role]
  end

  def role=(name)
    name = ROLES.index(name) if ROLES.include?(name)
    write_attribute(:role, name)
  end

  def to_json
    { email: email, name: name, role: role_name }
  end

  def self.random_agent
    agents.order('RAND()').first
  end
end
