require 'date'
require 'awesome_print'

start_date = Date.parse("Jan 1, 2019")
end_date = Date.parse('Jan 4, 2019')
start_date2 = Date.parse("Jan 1, 2019")
end_date2 = Date.parse('Jan 7, 2019')

date_range = (start_date..end_date-1).to_a
date_range2 = (start_date2..end_date2).to_a

ap date_range
ap date_range2
ap start_date
ap end_date
ap (date_range & date_range2).empty?
