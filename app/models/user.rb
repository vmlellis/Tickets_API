require 'utils'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, presence: true, uniqueness: true
  validates :name, :role, presence: true

  validates :auth_token, uniqueness: true

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

  def as_json(_)
    super.merge(role: role_name)
  end
end
