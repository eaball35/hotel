require_relative 'input_validation'

class RoomBlock
  
  attr_reader :booking_date_range, :collection_rooms, :discount
  attr_accessor :reserved_rooms

  def initialize(booking_date_range, collection_rooms, discount = 0, reserved_rooms = [])
    check_booking_date_range?(booking_date_range)
    check_num?(discount)
    collection_rooms.each {|room| check_room_reserved?(room, booking_date_range)}

    @booking_date_range = booking_date_range
    @collection_rooms = collection_rooms
    @discount = discount
    @reserved_rooms = reserved_rooms
  end
end