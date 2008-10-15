$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'test/unit'
require 'money'

class CoreExtensionsTest < Test::Unit::TestCase

  def setup
  end

  def test_numeric_conversion
    assert_equal Money.new(10000), 100.to_money
    assert_equal Money.new(10038), 100.38.to_money
    assert_equal Money.new(-10000), -100.to_money
  end

  def test_numeric_conversion_with_precision
    assert_equal Money.new(1000, Money.default_currency, 3), 1.to_money(3)
  end
    
  def test_string_conversion
    assert_equal Money.new(100), "$1".to_money
    assert_equal Money.new(100), "$1.00".to_money
    assert_equal Money.new(137), "$1.37".to_money
    assert_equal Money.new(100, 'CAD'), "CAD $1.00".to_money
    assert_equal Money.new(-10000), "-100".to_money
    assert_equal Money.new(410), "4.10".to_money
  end
  
  def test_string_with_other_precision
    assert_equal Money.new(500, 'USD', 2), '5'.to_money
    assert_equal Money.new(500, 'USD', 2), '5.0'.to_money
    assert_equal Money.new(500, 'USD', 2), '5.00'.to_money
    assert_equal Money.new(5055, 'USD', 3), '5.055'.to_money
    assert_equal Money.new(506, 'USD', 2), '5.055'.to_money(2)
  end
  
  def test_float_conversion_with_precision
    assert_equal Money.new(500, 'USD', 2), 5.0.to_money
    assert_equal Money.new(500, 'USD', 2), 5.00.to_money
    assert_equal Money.new(5055, 'USD', 3), 5.055.to_money
    assert_equal Money.new(506, 'USD', 2), 5.055.to_money(2)
  end
  
  def test_nil
    assert_raise(NoMethodError) do
      nil.to_money
    end
  end

end