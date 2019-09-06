# class RoomBlockBooker
    
#   attr_reader :@booking_date_range, :collection_rooms, :discount

#   def initialize(booking_date_range, collection_rooms, discount)
#     rooms_available?
    
#     @booking_date_range = booking_date_range
#     @collection_rooms = collection_rooms
#     @discount = discount

#   end

#   def rooms_available?
#     @collection_rooms.each do |room|
#       if !(room.unavailable_dates & @booking_date_range).empty?
#         raise ArgumentError.new('collection of rooms has unavaible room')
#       end
#     end
#   end
# end