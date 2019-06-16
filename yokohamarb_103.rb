require "minitest/autorun"
require "json"
require 'byebug'

def solve(src)
  # 愚直バージョン
  mask = src.to_i(16)
  result = (1..mask).select { |num| (mask & num) == num }
  result.size < 16 ? result.join(',') : truncate_result(result)
end

def truncate_result(result)
  result.take(13).join(',') + ',...,' + "#{result[-2]}," + result.last.to_s
end

if ! ARGV[0] || ! File.exist?( ARGV[0] )
  raise "you should specify json file as ARGV[0]"
end

class TestYokohamaRb103 < Minitest::Test
  json_string = File.open( ARGV[0], &:read )
  data = JSON.parse( json_string, symbolize_names:true )
  data[:test_data].each do | number:, src:, expected: |
    define_method( :"test_#{number}" ) do
      actual = solve(src)
      assert_equal( expected, actual )
    end
  end
end