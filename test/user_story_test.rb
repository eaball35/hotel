require_relative 'test_helper'

describe 'user stories' do
  let (:hotel)  {
    Hotel.new
  }
  let (:reservation_booker)  {
    hotel.reservation_booker
    }
  let (:new_booking_dates)  {
      BookingDates.new('Apr, 1 2019', 'Apr, 4 2019').booking_date_range
    }
  let (:input_date)  {
      Date.parse('Apr, 2 2019')
    }  

  describe 'wave 1' do
    it 'I can access the list of all of the rooms in the hotel' do
      hotel.add_rooms(20,200)

      expect(hotel.rooms).must_be_instance_of Array
      expect(hotel.rooms[0]).must_be_instance_of Room
      expect(hotel.rooms.length).must_equal 20
    end
    it 'I can make a reservation of a room for a given date range' do
      hotel.add_rooms(20,200)

      new_reservation = reservation_booker.book_reservation(new_booking_dates)

      expect(new_reservation).must_be_instance_of Reservation
      expect(new_reservation.booking_date_range).must_equal new_booking_dates
      expect(reservation_booker.reservations).must_include new_reservation
      expect(new_reservation.room.reservations).must_include new_reservation
    end
    
    it 'I can access the list of reservations for a specific date, so that I can track reservations by date' do
      hotel.add_rooms(3,200)

      new_reservation1 = reservation_booker.book_reservation(new_booking_dates)
      new_reservation2 = reservation_booker.book_reservation(new_booking_dates)

      reservations = reservation_booker.find_reservations_bydate(input_date)

      expect(reservations).must_be_instance_of Array
      expect(reservations.length).must_equal 2
      expect(reservations).must_include new_reservation1
      expect(reservations).must_include new_reservation2
    end
    
    it 'I can get the total cost for a given reservation' do
      hotel.add_rooms(3,200)

      new_reservation = reservation_booker.book_reservation(new_booking_dates)
      total_cost = reservation_booker.find_totalcost_byreservation(new_reservation)

      expect(total_cost).must_equal 600
    end
    
    it 'I want exception raised when an invalid date range is provided, so that I cant make a reservation for an invalid date range' do
      expect{BookingDates.new(nil, nil)}.must_raise StandardError
      expect{BookingDates.new('45', 'date')}.must_raise StandardError

      hotel.add_rooms(1,200)
      expect{reservation_booker.book_reservation('booking_date_range')}.must_raise StandardError
      expect{reservation_booker.book_reservation('Jan 1, 2019')}.must_raise StandardError
      expect{reservation_booker.book_reservation(nil)}.must_raise StandardError    
    end
  end

  describe 'wave 2' do
    it 'I can view a list of rooms that are not reserved for a given date range, so that I can see all available rooms for that day' do
      hotel.add_rooms(3,200)
      new_reservation = reservation_booker.book_reservation(new_booking_dates)
      available_rooms = reservation_booker.find_available_rooms(new_booking_dates)

      expect(available_rooms[0]).must_be_instance_of Room
      expect(available_rooms.length).must_equal 2
      expect(available_rooms).wont_include new_reservation.room
    end

    it 'I can get a reservation of a room for a given date range, and that room will not be part of any other reservation overlapping that date range' do
      hotel.add_rooms(2,200)
      new_reservation1 = reservation_booker.book_reservation(new_booking_dates)
      new_reservation2 = reservation_booker.book_reservation(new_booking_dates)

      expect(new_reservation1.room).wont_equal new_reservation2.room
    end

    it 'I want an exception raised if I try to reserve a room during a date range when all rooms are reserved, so that I cannot make two reservations for the same room that overlap by date' do
      hotel.add_rooms(2,200)
      new_reservation1 = reservation_booker.book_reservation(new_booking_dates)
      new_reservation2 = reservation_booker.book_reservation(new_booking_dates)

      expect{reservation_booker.book_reservation(new_booking_dates)}.must_raise StandardError
    end
  end

  describe 'wave 3' do
    it 'I can create a Hotel Block if I give a date range, collection of rooms, and a discounted room rate' do
      hotel.add_rooms(20,200)
      new_room_block = reservation_booker.book_roomblock(5, new_booking_dates , 20)
      
      expect(new_room_block).must_be_instance_of RoomBlock
  
      expect(new_room_block.booking_date_range).must_equal new_booking_dates
      
      expect(new_room_block.collection_rooms.length).must_equal 5
      expect(new_room_block.collection_rooms.first).must_be_instance_of Room

      expect(new_room_block.discount).must_equal 20
    end
    
    it 'I want an exception raised if I try to create a Hotel Block and at least one of the rooms is unavailable for the given date range' do
      hotel.add_rooms(5,200)
      new_reservation = reservation_booker.book_reservation(new_booking_dates)
      
      expect{reservation_booker.book_roomblock(5, new_booking_dates , 20)}.must_raise StandardError
    end
    
    it 'Given a specific date, and that a room is set aside in a hotel block for that specific date, I cannot reserve that specific room for that specific date, because it is unavailable' do
      hotel.add_rooms(5,200)
      new_room_block = reservation_booker.book_roomblock(5, new_booking_dates , 20)
      
      expect{reservation_booker.book_reservation(new_booking_dates)}.must_raise StandardError
    end
    
    it 'Given a specific date, and that a room is set aside in a hotel block for that specific date, I cannot create another hotel block that includes that specific room for that specific date, because it is unavailable' do
      hotel.add_rooms(5,200)
      new_room_block = reservation_booker.book_roomblock(5, new_booking_dates , 20)
      
      expect{reservation_booker.book_roomblock(5, new_booking_dates , 20)}.must_raise StandardError
    end
    
    it 'I can check whether a given block has any rooms available' do
      hotel.add_rooms(5,200)
      new_roomblock = reservation_booker.book_roomblock(5, new_booking_dates , 20)
      new_reservation = reservation_booker.book_roomblock_reservation(new_roomblock)
      available_rooms = reservation_booker.find_available_rooms_in_roomblock(new_roomblock)

      expect(new_roomblock.reserved_rooms.length).must_equal 1
      expect(available_rooms.length).must_equal 4
      expect(available_rooms.first).must_be_instance_of Room
      expect(available_rooms).wont_include new_reservation.room
    end
    
    it 'I can reserve a specific room from a hotel block' do
      hotel.add_rooms(5,200)
      new_roomblock = reservation_booker.book_roomblock(5, new_booking_dates , 20)

      new_reservation = reservation_booker.book_roomblock_reservation(new_roomblock)
      expect(new_reservation).must_be_instance_of Reservation
      expect(new_reservation.room.room_blocks).must_include new_roomblock
    end
    
    it 'I can only reserve that room from a hotel block for the full duration of the block' do
      hotel.add_rooms(5,200)
      new_roomblock = reservation_booker.book_roomblock(5, new_booking_dates , 20)

      partial_stay = BookingDates.new('Apr, 2 2019', 'Apr, 4 2019').booking_date_range
      expect{reservation_booker.book_reservation(partial_stay)}.must_raise StandardError

      new_reservation = reservation_booker.book_roomblock_reservation(new_roomblock)
      expect(new_reservation).must_be_instance_of Reservation
      expect(new_reservation.booking_date_range).must_equal new_booking_dates
    end
    
    it 'I can see a reservation made from a hotel block from the list of reservations for that date (see wave 1 requirements)' do
      hotel.add_rooms(5,200)
      new_roomblock = reservation_booker.book_roomblock(5, new_booking_dates , 20)
      new_reservation1 = reservation_booker.book_roomblock_reservation(new_roomblock)
      new_reservation2 = reservation_booker.book_roomblock_reservation(new_roomblock)

      expect(reservation_booker.reservations).must_include new_reservation1
      expect(reservation_booker.reservations).must_include new_reservation2
    end
  end

end