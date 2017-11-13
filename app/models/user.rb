require 'utils'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, presence: true, uniqueness: true
  validates :name, :role, presence: true

  validates :auth_token, uniqueness: true, allow_blank: true

  ROLES = %w[customer agent admin].freeze

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
