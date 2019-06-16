require "minitest/autorun"
require "json"

def solve(src)
  # 大前提:
  # mask適合となるnは、2進数で考慮した際、
  # maskにおいて1のbit以外に、1を持たない整数
  # e.g. mask = 11010(2進数, 16進数では1a)
  #         n = 00010 -> true
  #         n = 00011 -> false
  #         n = 00101 -> false
  #         n = 11000 -> true

  # 入力値を2進数に変換 -> '1'が立っている場所を抽出し、対応する数値を持つ配列を作る
  # e.g. 入力値 = '1a'の場合
  #      -> 2進数で'11010'
  #      -> 1, 3, 4bit目が'1' 
  #      -> [2 ** 1, 2 ** 3, 2 ** 4] = [2, 8, 16]となる配列を作成
  mask_adapt_partial = src.to_i(16).to_s(2).split('').reverse.map.with_index { |num, index| 2 ** index if num.eql?('1')}.compact

  # マスク適合可能な整数を出力する(resultメソッド参照)
  # ただし、mask_adapt_partialのサイズが5以上(マスク適合可能な整数が16個以上)の場合は、
  # 先頭から13個抽出＆大きい方から2個後ろにくっつける
  partial_size = mask_adapt_partial.size
  if partial_size < 5
    result(partial_size, mask_adapt_partial).join(',')
  else
    result(4, mask_adapt_partial)[0, 13].join(',') + ',...' + ",#{mask_adapt_partial.slice(1, partial_size).sum}" + ",#{mask_adapt_partial.sum}"
  end
end

def result(size, mask_adapt_partial)
  # 配列の組み合わせを抽出 & 組み合わせ毎の合計値を抽出 & flatten & sort
  # e.g. [2, 8, 16] 
  #      -> [[[2], [8], [16]], [[2, 8], [2, 16], [8, 16]], [[2, 8, 16]]] *イメージ
  #      -> [[2, 8, 16], [10, 18, 24], [26]] 
  #      -> [2, 8, 10, 16, 18, 24, 26]
  (1..size).collect do |index|
    mask_adapt_partial[0, size].combination(index).collect(&:sum)
  end.flatten.sort
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

private
