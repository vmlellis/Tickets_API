class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  ROLES = %w[customer agent admin].freeze

  def role=(name)
    name = ROLES.index(name) if ROLES.include?(name)
    write_attribute(:role, name) if ROLES[name]
  end
end
