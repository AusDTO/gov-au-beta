class Bundles::Holidays < DataBundle
  def self.value(arg)
    self.method(:arg).curry
  end

  #value :next_holiday

  def next_holiday
    Data::PublicHoliday.next_date
  end

  def data
    {
      'next_holiday' => method(:next_holiday).curry,
      'holidays' => Data::PublicHoliday.all
    }
  end
end
