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
    DateChecker.new('Apr, 1 2019', 'Apr, 4 2019').booking_date_range
  }

    describe 'initialize' do
      it 'new instance of Reservation_Booker is created with empty rooms and reservations' do
          expect(reservation_booker).must_be_instance_of ReservationBooker
          expect(hotel_rooms).must_equal []
          expect(hotel_reservations).must_equal []
      end
    end

    describe 'add_rooms' do
    
      it 'raise error if num_rooms is invalid' do
        expect{hotel.add_rooms("45",200)}.must_raise ArgumentError
        expect{hotel.add_rooms([],200)}.must_raise ArgumentError
      end

      it 'raise error if cost is invalid' do    
        expect{hotel.add_rooms(2,"200")}.must_raise ArgumentError
        expect{hotel.add_rooms([2],[200])}.must_raise ArgumentError
      end

      it 'adds new instances of Room with given cost for number of rooms times to @rooms variable' do
        hotel.add_rooms(20,200)

        expect(hotel_rooms[0]).must_be_instance_of Room
        expect(hotel_rooms.length).must_equal 20
    end
  end

  describe 'find_first_available_room' do
    it 'raises error if no rooms added' do
      expect{reservation_booker.find_first_available_room(new_booking_dates)}.must_raise ArgumentError
    end

    it 'returns the first available room, skip room when not available'  do
      hotel.add_rooms(2,200)
      
      new_reservation = reservation_booker.book_reservation(new_booking_dates)

      available_room2 = reservation_booker.find_first_available_room(new_booking_dates)
      
      expect(available_room2).must_be_instance_of Room
      expect(available_room2).wont_equal new_reservation.room
    end

    it 'returns nil if no available rooms for date range' do
      hotel.add_rooms(1,200)
  
      reservation_booker.book_reservation(new_booking_dates)

      available_room2 = reservation_booker.find_first_available_room(new_booking_dates)
      expect(available_room2).must_be_nil
    end

    it 'returns first room if hotel has rooms, but no bookings yet' do
      hotel.add_rooms(20,200)
      
      available_room = reservation_booker.find_first_available_room(new_booking_dates)
      
      expect(available_room).must_be_instance_of Room
      expect(available_room).must_equal hotel_rooms[0]
    end
  
    it 'allows reservation on the same day that another previous reservation ends' do
      hotel.add_rooms(1,200)
      new_booking_dates2 = DateChecker.new('Apr, 4 2019', 'Apr, 7 2019').booking_date_range
      
      reservation1 = reservation_booker.book_reservation(new_booking_dates)
      reservation2 = reservation_booker.book_reservation(new_booking_dates2)
      
      expect(reservation2.room).wont_be_nil
      expect(reservation2.room).must_equal reservation1.room
      expect(hotel_reservations.length).must_equal 2
    end
  end

  describe 'book_reservation' do
    it 'raises error if booking dates input is invalid'do
      hotel.add_rooms(1,200)
      available_room1 = reservation_booker.find_first_available_room(new_booking_dates)

      expect{reservation_booker.book_reservation("booking_dates")}.must_raise ArgumentError
      expect{reservation_booker.book_reservation(20)}.must_raise ArgumentError
      expect{reservation_booker.book_reservation(nil)}.must_raise ArgumentError
    end

    it 'raises error if booking dates input not contains Dates' do
      hotel.add_rooms(1,200)

      expect{reservation_booker.book_reservation(['Apr, 1 2019', 'Apr, 4 2019'])}.must_raise ArgumentError
    end

    it 'returns new reservation given booking dates' do
      hotel.add_rooms(1,200)
      new_reservation = reservation_booker.book_reservation(new_booking_dates)

      expect(new_reservation).must_be_instance_of Reservation
      expect(new_reservation.room).must_equal hotel_rooms[0]
      expect(new_reservation.booking_date_range).must_equal new_booking_dates
    end

    it 'new reservation should be added to rooms list of reservations' do
      hotel.add_rooms(1,200)
      new_booking_dates2 = DateChecker.new('Apr, 6 2019', 'Apr, 10 2019').booking_date_range
      
      reservation1 = reservation_booker.book_reservation(new_booking_dates)
      reservation2 = reservation_booker.book_reservation(new_booking_dates2)

      expect(reservation1.room.reservations.length).must_equal 2
      expect(reservation2.room.reservations.length).must_equal 2
      expect(reservation1.room.reservations[0]).must_be_instance_of Reservation
    end

    it 'new reservation booking dates should be added to rooms unavailable dates' do
      hotel.add_rooms(1,200)
      
      new_reservation = reservation_booker.book_reservation(new_booking_dates)

      expect(new_reservation.room.unavailable_dates).must_equal new_booking_dates
    end

    it 'raises error if inputed room already has reservation on inputed dates' do
      hotel.add_rooms(1,200)
      
      reservation_booker.book_reservation(new_booking_dates)
      
      expect{reservation_booker.book_reservation(new_booking_dates)}.must_raise ArgumentError
    end
  end

  describe 'find_reservations_bydate' do
    let (:input_date)  {
      Date.parse('Apr, 1 2019')
    }

    it 'returns list of reservations on given date' do
        hotel.add_rooms(2,200)
        
        reservation1 = reservation_booker.book_reservation(new_booking_dates)
        reservation2 = reservation_booker.book_reservation(new_booking_dates)

        reservations_on_date = reservation_booker.find_reservations_bydate(input_date)
        expect(reservations_on_date.length).must_equal 2
        expect(reservations_on_date).must_include reservation1
        expect(reservations_on_date).must_include reservation2
    end

    it 'returns nil if there are no reservations yet' do
      reservations_on_date = reservation_booker.find_reservations_bydate(input_date)

      expect(reservations_on_date).must_be_nil
    end

    it 'raises error if date input is invalid' do
      expect{reservation_booker.find_reservations_bydate('Apr, 1 2019')}.must_raise ArgumentError
      expect{reservation_booker.find_reservations_bydate(20)}.must_raise ArgumentError
      expect{reservation_booker.find_reservations_bydate(nil)}.must_raise ArgumentError
    end
  end

  describe 'find_available_rooms_bydate' do
    let (:input_date)  {
      Date.parse('Apr, 2 2019')
    }
    
    it 'raises error if no rooms added yet' do
      expect{reservation_booker.find_available_rooms_bydate(input_date)}.must_raise ArgumentError
    end

    it 'raises error if date input is invalid' do
      hotel.add_rooms(2,200)
      expect{reservation_booker.find_available_rooms_bydate('input_date')}.must_raise ArgumentError
      expect{reservation_booker.find_available_rooms_bydate([input_date, input_date])}.must_raise ArgumentError
      expect{reservation_booker.find_available_rooms_bydate('Apr 1, 2019')}.must_raise ArgumentError
    end
    
    it 'finds list of avaible rooms by date, ignoring unavaible rooms' do
      hotel.add_rooms(20,200)
      
      new_reservation = reservation_booker.book_reservation(new_booking_dates)

      found_rooms = reservation_booker.find_available_rooms_bydate(input_date)

      expect(found_rooms).must_be_instance_of Array
      expect(found_rooms.length).must_equal 19
      expect(found_rooms[0]).must_be_instance_of Room
      expect(found_rooms).wont_include new_reservation.room
    end
  end

  describe 'find_totalcost_byreservation' do
    it 'returns total cost for given reservation' do
      hotel.add_rooms(2,200)
      reservation = reservation_booker.book_reservation(new_booking_dates)

      total_cost = reservation_booker.find_totalcost_byreservation(reservation)

      expect(total_cost).must_equal 600
    end

    it 'raises an error if reservation is invalid' do
      expect{reservation_booker.find_totalcost_byreservation('reservation')}.must_raise ArgumentError
      expect{reservation_booker.find_totalcost_byreservation(nil)}.must_raise ArgumentError
    end

    it 'raises an error if reservation doesnt exist in list of hotel reservations' do
      hotel.add_rooms(1,200)
      reservation = Reservation.new(hotel_rooms[0], new_booking_dates)

      expect{reservation_booker.find_totalcost_byreservation(reservation)}.must_raise ArgumentError
    end

  end

end
