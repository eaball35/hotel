class Reservation
  attr_reader :room, :booking_date_range
  
  def initialize(room, booking_date_range)
    @room = room
    @booking_date_range = booking_date_range
  end
end