#!/usr/bin/env ruby
require 'bio-gff3'

opts = {}
opts[:validate]         = false
opts[:parser]           = :line
opts[:block]            = false
opts[:cache_components] = true
opts[:cache_records]    = true
opts[:fix_wormbase]     = true
opts[:fix]              = true
opts[:no_assemble]      = true
opts[:phase]            = true
opts[:debug]            = false


gff3 = Bio::GFFbrowser::GFF3.new(ARGV.first, opts)


