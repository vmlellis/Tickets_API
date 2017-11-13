class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, presence: true, uniqueness: true
  validates :name, :role, presence: true

  ROLES = %w[customer agent admin].freeze

  def role_name
    ROLES[role]
  end

  def role=(val)
    val = ROLES.index(val) if ROLES.include?(val)
    val = Integer(val) rescue nil
    return if val.nil?
    write_attribute(:role, val) if ROLES[val]
  end
end
