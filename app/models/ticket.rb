class Ticket < ApplicationRecord
  STATUS = %w[new in_progress closed].freeze
end
