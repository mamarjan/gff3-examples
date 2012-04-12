#!/usr/bin/env ruby
require 'bio'

count = 0

gfffile = Bio::GFF::GFF3.new(ARGF)
gfffile.records.each do |rec|
  count += 1
end

puts "The file has #{count} records."

