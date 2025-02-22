require_relative 'test_helper'
require 'date'

describe 'booking_dates' do

    let (:date1)  {
        BookingDates.new(start_date: "Jan 1, 2019", end_date: "Jan 4, 2019")
      }
    let (:start1)  {
        date1.start_date
      }
    let (:end1)  {
        date1.end_date
    }
    let (:booking_date_range1)  {
        date1.booking_date_range
    }

    it 'should raise error if end date or start date are nil' do
        expect{BookingDates.new(start_date: nil, end_date: "Jan 4, 2019")}.must_raise StandardError
        expect{BookingDates.new(start_date: "Jan 1, 2019", end_date: nil)}.must_raise StandardError
    end

    it 'should raise error if end date is before start date' do
        expect{BookingDates.new(start_date: "Jan 14, 2019", end_date: "Jan 4, 2019")}.must_raise StandardError
    end

    it 'instance end and start date variables should be instance of Time' do
        expect(start1).must_be_instance_of Date
        expect(end1).must_be_instance_of Date
    end

    it 'booking date range should include all date within start/end, not including last day' do
        expect(booking_date_range1).must_be_instance_of Array
        expect(booking_date_range1.length).must_equal 3
        expect(booking_date_range1[0]).must_be_instance_of Date
        expect(booking_date_range1[0]).must_equal start1
        expect(booking_date_range1[-1]).must_equal (end1 - 1)
    end

    it 'booking date range should not include last input date' do
        last_day = Date.parse("Jan 4, 2019")
        expect(booking_date_range1).wont_include last_day
    end
end