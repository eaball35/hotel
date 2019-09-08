require_relative 'input_validation'

class Reservation
  attr_reader :room, :booking_date_range, :price, :discount
  
  def initialize(room, booking_date_range, discount = 0)
    check_room(room)
    check_booking_date_range(booking_date_range)
    check_num(discount)
    
    @room = room
    @booking_date_range = booking_date_range
    @num_nights = booking_date_range.length
    @discount = (discount/100.0).to_f
    @price = @room.cost * @num_nights * (1 - @discount)
  end
end