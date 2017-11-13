class Ticket < ApplicationRecord
  STATUS = %w[new in_progress closed].freeze

  def status_name
    STATUS[status]
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
