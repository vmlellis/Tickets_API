require 'utils'

class User < ApplicationRecord
  ROLES = %w[customer agent admin].freeze

  has_many  :created_tickets,
            foreign_key: 'created_by_id',
            class_name: 'Ticket',
            dependent: :restrict_with_error

  has_many  :support_tickets,
            foreign_key: 'agent_id',
            class_name: 'Ticket',
              dependent: :restrict_with_error

  has_many  :closed_tickets,
            foreign_key: 'closed_by_id',
            class_name: 'Ticket',
            dependent: :restrict_with_error

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, presence: true, uniqueness: true
  validates :name, :role, presence: true

  validates :auth_token, uniqueness: true, allow_blank: true

  ROLES.each do |role_name|
    define_method("#{role_name}?") { role == ROLES.index(role_name) }
  end

  def role_name
    ROLES[role]
  end

  def role=(val)
    if ROLES.include?(val)
      write_attribute(:role, ROLES.index(val))
    elsif Utils.int?(val) && ROLES[val.to_i]
      write_attribute(:role, val)
    end
  end

  def generate_auth_token!
    return auth_token if auth_token.present?
    new_token = Devise.friendly_token(32)
    update_columns(auth_token: new_token)
    new_token
  rescue ActiveRecord::RecordNotUnique
    generate_auth_token!
  end

  def remove_auth_token!
    update_columns(auth_token: nil) if auth_token.present?
  end

  def as_json(_ = {})
    super.merge(role: role_name)
  end
end
