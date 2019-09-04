require 'date'

class DateChecker

  attr_reader :start_date, :end_date, :booking_date_range

  def initialize(start_date, end_date)
    raise ArgumentError.new("Time inputs are nil") if end_date == nil || start_date == nil
    
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
    
    raise ArgumentError.new("End date is after start date") if @end_date < @start_date

    @booking_date_range = (@start_date..@end_date - 1).to_a
  end

end


