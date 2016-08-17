class Data::PublicHoliday < ApplicationRecord
  self.table_name = 'data_public_holidays'

  class << self
    delegate :date, to: :next, allow_nil: true, prefix: true
  end

  def self.next
    order(:date).find_by('date >= ?', Date.today)
  end
end
