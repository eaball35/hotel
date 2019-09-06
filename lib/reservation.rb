class Reservation
  attr_reader :room, :booking_date_range, :price
  
  def initialize(room, booking_date_range)
    @room = room
    @booking_date_range = booking_date_range
    @price = @room.cost * (booking_date_range.length)
  end
end