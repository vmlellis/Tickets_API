class Ticket < ApplicationRecord
  STATUS = %w[new in_progress closed].freeze

  has_many :ticket_topics

  belongs_to :created_by, class_name: 'User'
  belongs_to :agent, class_name: 'User'
  belongs_to :closed_by, class_name: 'User', optional: true
  belongs_to :ticket_type

  validates :title, :description, :created_by_id, :agent_id, :ticket_type_id,
            presence: true

  scope :status_new, -> { where(status: STATUS.index('new')) }
  scope :status_in_progress, -> { where(status: STATUS.index('in_progress')) }
  scope :status_closed, -> { where(status: STATUS.index('closed')) }

  scope :closed_in_last_month, lambda {
    where('DATE(closed_at) >= ?', 1.month.ago.to_date)
  }

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
