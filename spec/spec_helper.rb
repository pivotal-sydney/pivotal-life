require 'vcr'
require 'pry'
require 'coveralls'
Coveralls.wear!

require_relative '../lib/local_stations'

VCR.configure do |c|
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.cassette_library_dir = 'spec/fixtures/cassettes'
end

