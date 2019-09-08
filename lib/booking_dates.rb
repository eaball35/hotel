require 'date'

class BookingDates

  attr_reader :start_date, :end_date, :booking_date_range

  def initialize(start_date, end_date)
    check_nil(start_date)
    check_nil(end_date)
    
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
    check_end_after_start(@start_date, @end_date)

    @booking_date_range = (@start_date..@end_date - 1).to_a
  end

end


