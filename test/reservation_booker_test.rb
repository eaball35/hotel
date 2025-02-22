require_relative 'test_helper'

describe 'reservation_booker' do
  let (:hotel)  {
    Hotel.new
  }
  let (:hotel_rooms)  {
    hotel.rooms
  }
  let (:reservation_booker)  {
    hotel.reservation_booker
  }
  
  let (:hotel_reservations)  {
    hotel.reservation_booker.reservations
  }
  let (:new_booking_dates)  {
    BookingDates.new(start_date: 'Apr, 1 2019', end_date: 'Apr, 4 2019').booking_date_range
  }

    describe 'initialize' do
      it 'new default instance of Reservation_Booker is created with empty rooms and reservations' do
          expect(reservation_booker).must_be_instance_of ReservationBooker
          expect(hotel_rooms).must_equal []
          expect(hotel_reservations).must_equal []
      end
    end

  describe 'find_available_rooms' do
    it 'raises error if no rooms added' do
      expect{reservation_booker.find_available_rooms(booking_date_range: new_booking_dates)}.must_raise StandardError
    end

    it 'returns the first available room, skip room when not available'  do
      hotel.add_rooms(num_rooms: 2)
      
      new_reservation = reservation_booker.book_reservation(booking_date_range: new_booking_dates)

      available_rooms = reservation_booker.find_available_rooms(booking_date_range: new_booking_dates)
      
      expect(available_rooms.length).must_equal 1
      expect(available_rooms).wont_include new_reservation.room
    end

    it 'returns [] if no available rooms for date range' do
      hotel.add_rooms(num_rooms: 1)
  
      reservation_booker.book_reservation(booking_date_range: new_booking_dates)

      available_rooms = reservation_booker.find_available_rooms(booking_date_range: new_booking_dates)
      expect(available_rooms).must_equal []
    end

    it 'returns all rooms if hotel has rooms, but no bookings yet' do
      hotel.add_rooms(num_rooms: 20)
      
      available_rooms = reservation_booker.find_available_rooms(booking_date_range: new_booking_dates)
      
      expect(available_rooms.length).must_equal 20
    end
  
    it 'allows reservation on the same day that another previous reservation ends' do
      hotel.add_rooms(num_rooms: 1)
      new_booking_dates2 = BookingDates.new(start_date:'Apr, 4 2019', end_date: 'Apr, 7 2019').booking_date_range
      
      reservation1 = reservation_booker.book_reservation(booking_date_range: new_booking_dates)
      reservation2 = reservation_booker.book_reservation(booking_date_range: new_booking_dates2)
      
      expect(reservation2.room).wont_be_nil
      expect(reservation2.room).must_equal reservation1.room
      expect(hotel_reservations.length).must_equal 2
    end
  end

  describe 'book_reservation' do
    before do
      hotel.add_rooms(num_rooms: 1)
    end
    it 'raises error if booking dates input is invalid'do
      expect{reservation_booker.book_reservation(booking_date_range: "booking_dates")}.must_raise StandardError
      expect{reservation_booker.book_reservation(booking_date_range: 20)}.must_raise StandardError
      expect{reservation_booker.book_reservation(booking_date_range: nil)}.must_raise StandardError
    end

    it 'raises error if booking dates input not contains Dates' do
      expect{reservation_booker.book_reservation(booking_date_range: ['Apr, 1 2019', 'Apr, 4 2019'])}.must_raise StandardError
    end

    it 'returns new reservation given booking dates' do
      new_reservation = reservation_booker.book_reservation(booking_date_range: new_booking_dates)

      expect(new_reservation).must_be_instance_of Reservation
      expect(new_reservation.room).must_equal hotel_rooms[0]
      expect(new_reservation.booking_date_range).must_equal new_booking_dates
    end

    it 'new reservation should be added to rooms list of reservations' do
      new_booking_dates2 = BookingDates.new(start_date: 'Apr, 6 2019', end_date: 'Apr, 10 2019').booking_date_range
      
      reservation1 = reservation_booker.book_reservation(booking_date_range: new_booking_dates)
      reservation2 = reservation_booker.book_reservation(booking_date_range: new_booking_dates2)

      expect(reservation1.room.reservations.length).must_equal 2
      expect(reservation2.room.reservations.length).must_equal 2
      expect(reservation1.room.reservations.first).must_be_instance_of Reservation
    end

    it 'new reservation booking dates should be added to rooms unavailable dates' do
      new_reservation = reservation_booker.book_reservation(booking_date_range: new_booking_dates)

      expect(new_reservation.room.unavailable_dates).must_equal new_booking_dates
    end

    it 'raises error if inputed room already has reservation on inputed dates' do
      reservation_booker.book_reservation(booking_date_range: new_booking_dates)
      
      expect{reservation_booker.book_reservation(booking_date_range: new_booking_dates)}.must_raise StandardError
    end
  end

  describe 'find_reservations_bydate' do
    let (:input_date)  {
      Date.parse('Apr, 1 2019')
    }

    it 'returns list of reservations on given date' do
        hotel.add_rooms(num_rooms: 2)
        
        reservation1 = reservation_booker.book_reservation(booking_date_range: new_booking_dates)
        reservation2 = reservation_booker.book_reservation(booking_date_range: new_booking_dates)

        reservations_on_date = reservation_booker.find_reservations_bydate(input_date)
        expect(reservations_on_date.length).must_equal 2
        expect(reservations_on_date).must_include reservation1
        expect(reservations_on_date).must_include reservation2
    end

    it 'raises error if there are no reservations yet' do
      expect{reservation_booker.find_reservations_bydate(input_date)}.must_raise StandardError
    end

    it 'raises error if date input is invalid' do
      expect{reservation_booker.find_reservations_bydate('Apr, 1 2019')}.must_raise StandardError
      expect{reservation_booker.find_reservations_bydate(20)}.must_raise StandardError
      expect{reservation_booker.find_reservations_bydate(nil)}.must_raise StandardError
    end
  end

  describe 'find_available_rooms' do
    it 'raises error if no rooms added yet' do
      expect{reservation_booker.find_available_rooms(booking_date_range: new_booking_dates)}.must_raise StandardError
    end

    it 'raises error if date input is invalid' do
      hotel.add_rooms(num_rooms: 2)
      expect{reservation_booker.find_available_rooms(booking_date_range: 'new_booking_dates')}.must_raise StandardError
      expect{reservation_booker.find_available_rooms(booking_date_range: 'Apr 1, 2019')}.must_raise StandardError
    end
    
    it 'finds list of avaible rooms by date, ignoring unavaible rooms' do
      hotel.add_rooms(num_rooms: 20)
      
      new_reservation = reservation_booker.book_reservation(booking_date_range: new_booking_dates)

      found_rooms = reservation_booker.find_available_rooms(booking_date_range: new_booking_dates)

      expect(found_rooms).must_be_instance_of Array
      expect(found_rooms.length).must_equal 19
      expect(found_rooms.first).must_be_instance_of Room
      expect(found_rooms).wont_include new_reservation.room
    end
  end

  describe 'find_totalcost_byreservation' do
    it 'returns total cost for given reservation' do
      hotel.add_rooms(num_rooms: 2)
      reservation = reservation_booker.book_reservation(booking_date_range:new_booking_dates)

      total_cost = reservation_booker.find_totalcost_byreservation(reservation)

      expect(total_cost).must_equal 600
    end

    it 'raises an error if reservation is invalid' do
      expect{reservation_booker.find_totalcost_byreservation('reservation')}.must_raise StandardError
      expect{reservation_booker.find_totalcost_byreservation(nil)}.must_raise StandardError
    end

    it 'raises an error if reservation doesnt exist in list of hotel reservations' do
      hotel.add_rooms(num_rooms: 1)
      reservation = Reservation.new(room: hotel_rooms.first, booking_date_range: new_booking_dates)

      expect{reservation_booker.find_totalcost_byreservation(reservation)}.must_raise StandardError
    end

    it 'returns price correctly for discounted rooms' do
      hotel.add_rooms(num_rooms: 5)
      room_block = reservation_booker.book_roomblock(num_rooms: 5, booking_date_range: new_booking_dates , discount: 20)
      
      reservation = reservation_booker.book_roomblock_reservation(room_block: room_block)
      expect(reservation.price).must_equal 480
    end
  end

  describe 'book_roomblock' do
    before do
      hotel.add_rooms(num_rooms:5)
      @room_block = reservation_booker.book_roomblock(num_rooms: 5, booking_date_range: new_booking_dates , discount: 20)
    end
    
    it 'returns a new instance of book_roomblock given num_rooms, booking_date_range , & discount' do 
      expect(@room_block).must_be_instance_of RoomBlock
      expect(@room_block.booking_date_range).must_equal new_booking_dates
      expect(@room_block.collection_rooms.length).must_equal 5
      expect(@room_block.discount).must_equal 20
    end

    it 'adds new roomblock to list of roomblocks' do 
      expect(reservation_booker.room_blocks.length).must_equal 1
      expect(reservation_booker.room_blocks.first).must_equal @room_block
    end

    it 'adds new roomblock to list of roomblocks for each room in block' do
      hotel.rooms.each { |room|
      expect(room.room_blocks.first).must_equal @room_block
      }
    end

    it 'adds booking dates to rb_unavailable_dates list for reach room in block' do
      hotel.rooms.each { |room|
      expect(room.rb_unavailable_dates).must_equal new_booking_dates
      }
    end

    it 'raises error if try to book roomblock when no rooms available' do
      expect{reservation_booker.book_roomblock(num_rooms: 5, booking_date_range: new_booking_dates)}.must_raise StandardError
    end

    it 'raises error if try to book a regular reservation when room has roomblock during date range' do
      expect{reservation_booker.book_reservation(booking_date_range: new_booking_dates)}.must_raise StandardError
    end

    it 'raises error if try to book another roomblock overlapping current roomblock' do
      new_dates = BookingDates.new(start_date: 'Apr, 3 2019', end_date: 'Apr, 6 2019').booking_date_range
      expect{reservation_booker.book_roomblock(num_rooms: 5, booking_date_range: new_dates)}.must_raise StandardError
    end

    it 'raises error if try to book roomblock with more than 5 rooms' do
      new_dates = BookingDates.new(start_date: 'May, 1 2019', end_date: 'May, 4 2019').booking_date_range
      expect{reservation_booker.book_roomblock(num_rooms: 10, booking_date_range: new_dates)}.must_raise StandardError
      expect{reservation_booker.book_roomblock(num_rooms: 15, booking_date_range:  new_dates)}.must_raise StandardError
      expect{reservation_booker.book_roomblock(6, new_dates , 20)}.must_raise StandardError
    end
  end

  describe 'book_roomblock_reservation' do
    before do
      hotel.add_rooms(num_rooms: 20)
      @room_block = reservation_booker.book_roomblock(num_rooms: 5, booking_date_range: new_booking_dates)
      @reservations = reservation_booker.book_roomblock_reservation(room_block: @room_block, num_rooms: 2)
    end
    it 'books a reservation from roomblock' do
      expect(@reservations).must_be_instance_of Array
      expect(@reservations.length).must_equal 2
      expect(@reservations.first).must_be_instance_of Reservation
      expect(@reservations.first.booking_date_range).must_equal new_booking_dates
      expect(@reservations.first.booking_date_range).must_equal new_booking_dates   
    end
    
    it 'cannot book more rooms than are available in room block' do
      expect{reservation_booker.book_roomblock_reservation(room_block: @room_block, num_rooms: 4)}.must_raise StandardError
    end
  end

end
