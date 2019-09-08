require_relative 'test_helper'

describe 'room tests' do
  
  let (:room)  {
    Room.new
  }
  
  it 'should create new instance of room with given cost' do
    expect(room).must_be_instance_of Room
    expect(room.cost).must_equal 200
  end

  it 'should raise error if cost input is invalid'do
  expect{Room.new(cost: '200')}.must_raise StandardError
  expect{Room.new(cost: nil)}.must_raise StandardError
  end
end