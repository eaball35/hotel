require_relative 'test_helper'

describe 'room_block_booker' do
  let (:hotel)  {
    Hotel.new
  }
  let (:reservation_booker)  {
    hotel.reservation_booker
    }
  let (:new_booking_dates)  {
      BookingDates.new(start_date: 'Apr, 1 2019', end_date: 'Apr, 4 2019').booking_date_range
    }
  let (:input_date)  {
      Date.parse('Apr, 2 2019')
    }
  let (:discount)  {
      0.2
    }
  let (:collection_rooms)  {
    hotel.add_rooms(num_rooms: 3, cost: 200)
    reservation_booker.book_reservation(booking_date_range: new_booking_dates)
    reservation_booker.book_reservation(booking_date_range: new_booking_dates)
    reservation_booker.book_reservation(booking_date_range: new_booking_dates)
    [hotel.rooms[0],hotel.rooms[1],hotel.rooms[2]]
  }

    
    it 'initalized with booking date range, collection of rooms, and discount' do
        collection_rooms = []
        new_room_block = RoomBlock.new(booking_date_range: new_booking_dates, collection_rooms: collection_rooms, discount: discount)

        expect(new_room_block).must_be_instance_of RoomBlock
        expect(new_room_block.booking_date_range).must_equal new_booking_dates
        expect(new_room_block.collection_rooms).must_equal collection_rooms
        expect(new_room_block.discount).must_equal discount
    end

    it 'raises error if any room in block is already booked during booking date range' do
      expect{RoomBlock.new(booking_date_range: new_booking_dates, collection_rooms: collection_rooms, discount: discount)}.must_raise StandardError
    end
end