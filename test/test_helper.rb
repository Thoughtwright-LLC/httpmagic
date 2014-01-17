$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

require 'rubygems'
gem 'minitest' if RUBY_VERSION > '1.9'
require 'minitest/autorun'
require 'webmock/minitest'
require 'pry'

# Retreive the contents of fixture files to be used in tests.  It is easier
# to view, modify and visualize text used in tests when it is stored in files.
# Also, it is much easier to reuse that text.
def fixture_file(file_name)
  File.open(fixture_file_path(file_name), 'rb').read
end

def fixture_file_path(file_name)
  File.join(File.dirname(__FILE__), 'fixtures', file_name)
end
