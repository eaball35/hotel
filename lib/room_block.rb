require_relative 'input_validation'

class RoomBlock
  
  attr_reader :booking_date_range, :collection_rooms, :discount

  def initialize(booking_date_range, collection_rooms, discount)
    check_booking_date_range(booking_date_range)
    collection_rooms.each {|room| room_reserved?(room, booking_date_range)}
    check_num(discount)

    @booking_date_range = booking_date_range
    @collection_rooms = collection_rooms
    @discount = discount
  end
end