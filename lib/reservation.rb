class Reservation
  attr_reader :room, :booking_date_range, :price, :discount
  
  def initialize(room, booking_date_range, discount = 0)
    @room = room
    @booking_date_range = booking_date_range
    @num_nights = booking_date_range.length
    @discount = discount/100.0
    @price = @room.cost * @num_nights * (1 - @discount)
  end
end