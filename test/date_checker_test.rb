require_relative 'test_helper'


describe 'date_checker tests' do
    it 'should raise error if end date or start date are nil' do
        expect{DateChecker.new(nil, "Jan 4, 2019")}.must_raise ArgumentError
        expect{DateChecker.new("Jan 1, 2019", nil)}.must_raise ArgumentError
    end

    it 'should raise error if end date is before start date' do
        expect{DateChecker.new("Jan 14, 2019", "Jan 4, 2019")}.must_raise ArgumentError
    end

    it 'instance end and start date variables should be instance of Time' do
        testdate = DateChecker.new("Jan 1, 2019", "Jan 4, 2019")
        
        expect(testdate.start_date).must_be_instance_of Date
        expect(testdate.end_date).must_be_instance_of Date
    end

    it 'booking date range should include all date within start/end, not including last day' do
        testdate = DateChecker.new("Jan 1, 2019", "Jan 4, 2019")
        start_date = testdate.start_date
        end_date = testdate.end_date
        booking_date_range = testdate.booking_date_range
        
        expect(booking_date_range).must_be_instance_of Array
        expect(booking_date_range.length).must_equal 3
        expect(booking_date_range[0]).must_be_instance_of Date
        expect(booking_date_range[0]).must_equal start_date
        expect(booking_date_range[-1]).must_equal (end_date-1)
    end
end