class Ticket < ApplicationRecord
  STATUS = %w[new in_progress closed].freeze

  belongs_to :created_by, class_name: 'User'
  belongs_to :agent, class_name: 'User'
  belongs_to :closed_by, class_name: 'User', optional: true
  belongs_to :ticket_type

  validates :title, :description, :created_by_id, :created_at, :agent_id,
            :ticket_type_id, presence: true

  def status_name
    STATUS[status.to_i]
  end

  def status=(val)
    if STATUS.include?(val)
      write_attribute(:status, STATUS.index(val))
    elsif Utils.int?(val) && STATUS[val.to_i]
      write_attribute(:status, val)
    end
  end

  def as_json(_ = {})
    super.merge(status: status_name)
  end
end
