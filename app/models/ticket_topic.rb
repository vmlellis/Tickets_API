class TicketTopic < ApplicationRecord
  belongs_to :user
  belongs_to :ticket

  validates :description, :user_id, :ticket_id, presence: true
end
