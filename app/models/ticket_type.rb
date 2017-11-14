class TicketType < ApplicationRecord
  has_many :tickets

  validates :name, presence: true, uniqueness: true
end
