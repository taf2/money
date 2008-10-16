$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'test/unit'
require 'money'

class MoneyTest < Test::Unit::TestCase
  
  def setup
    
    @can1  = Money.ca_dollar(100)
    @can2  = Money.ca_dollar(200)
    @can3  = Money.ca_dollar(300)
    @us1   = Money.us_dollar(100)
    
    Money.bank = NoExchangeBank.new
    Money.default_currency = "USD"
    
  end
  
  def test_sanity

    assert_equal @can1, @can1
    assert_equal true, @can1 < @can2
    assert_equal true, @can3 > @can2
    assert_equal [@can1, @can2, @can3], [@can1, @can2, @can3]
    assert_equal [@can1, @can2, @can3], [@can3, @can2, @can1].sort
    assert_not_equal [@can1, @can2, @can3], [@can3, @can2, @can1]
    assert_equal [@can1], [@can1, @can2, @can3] & [@can1]

    assert_equal [@can1, @can2], [@can1] | [@can2]

    
    assert_equal @can3, @can1 + @can2
    assert_equal @can1, @can2 - @can1
    
    assert_equal Money.ca_dollar(500), Money.ca_dollar(10) + Money.ca_dollar(90) + Money.ca_dollar(500) - Money.ca_dollar(100)
      
  end
  
  def test_default_currency
    
    assert_equal Money.new(100).currency, "USD"
    Money.default_currency = "CAD"
    assert_equal Money.new(100).currency, "CAD"
  end
  
  def test_default_exchange   
    assert_raise(Money::MoneyError) do
      Money.us_dollar(100).exchange_to("CAD")
    end   
  end
  
  def test_zero
    assert_equal true, Money.empty.zero?
    assert_equal false, Money.ca_dollar(1).zero?
    assert_equal false, Money.ca_dollar(-1).zero?
  end
  
  def test_real_exchange   
    Money.bank = VariableExchangeBank.new
    Money.bank.add_rate("USD", "CAD", 1.24515)
    Money.bank.add_rate("CAD", "USD", 0.803115)
    assert_equal Money.us_dollar(100).exchange_to("CAD"), Money.ca_dollar(124)
    assert_equal Money.ca_dollar(100).exchange_to("USD"), Money.us_dollar(80)
  end
    
  def test_multiply    
    assert_equal Money.ca_dollar(5500), Money.ca_dollar(100) * 55    
    assert_equal Money.ca_dollar(150), Money.ca_dollar(100) * 1.50
    assert_equal Money.ca_dollar(50), Money.ca_dollar(100) * 0.50
  end
  
  def test_multiply_with_precision
    assert_equal Money.new(1008, 'USD', 3), (Money.new(504, 'USD', 3) * 2)
  end
  
  def test_divide
    assert_equal Money.ca_dollar(100), Money.ca_dollar(5500) / 55    
    assert_equal Money.ca_dollar(100), Money.ca_dollar(200) / 2    
  end

  def test_divide_with_other_precision
    assert_equal Money.new(100, 'USD', 3), Money.new(5500, 'USD', 3) / 55
    assert_equal Money.new(100, 'USD', 3), Money.new(200, 'USD', 3) / 2
  end
  
  def test_add_with_other_precision
    assert_equal Money.new(1000, 'USD', 3), Money.new(30, 'USD', 2) + Money.new(700, 'USD', 3)
  end
  
  def test_subtract_with_other_precision
    assert_equal Money.new(450, 'USD', 3), Money.new(50, 'USD', 2) - Money.new(50, 'USD', 3)
  end
  
  def test_negative
    assert_equal Money.new(-43, 'CAD', 2), -Money.new(43, 'CAD', 2)
    assert_equal Money.new(-2979, 'CAD', 3), -Money.new(2979, 'CAD', 3)
  end
  
  def test_empty_can_exchange_currency
    Money.bank = VariableExchangeBank.new
    Money.bank.add_rate("CAD", "USD", 1)
    Money.bank.add_rate("USD", "CAD", 1)
    assert_equal Money.us_dollar(100), Money.empty('USD') + Money.ca_dollar(100)
    assert_equal Money.ca_dollar(100), Money.ca_dollar(100) + Money.empty('USD')
    
    assert_equal Money.us_dollar(-100), Money.empty('USD') - Money.ca_dollar(100)
    assert_equal Money.ca_dollar(-100), Money.ca_dollar(-100) - Money.empty('USD')
  end
  
  def test_to_s
    assert_equal "1.00", @can1.to_s
    assert_equal "390.50", Money.ca_dollar(39050).to_s
  end
  
  def test_to_s_with_other_precision
    assert_equal "0.505", Money.new(505, 'USD', 3).to_s
    assert_equal "4", Money.new(4, 'USD', -3).to_s
    assert_equal "4000", Money.new(4, 'USD', -3).to_s(0)
    assert_equal "0.51", Money.new(505, 'USD', 3).to_s(2)
    assert_equal "0.50", Money.new(504, 'USD', 3).to_s(2)
    assert_equal "1.00", Money.new(1001, 'USD', 3).to_s(2)
  end
  
  def test_substract_from_zero
   assert_equal -12.to_money, Money.empty - (12.to_money)
  end
  
  def test_formatting
    assert_equal "$1.00", @can1.format 
    assert_equal "$1.00 CAD", @can1.format(:with_currency)

    assert_equal "$1", @can1.format(:no_cents)
    assert_equal "$5", Money.ca_dollar(570).format(:no_cents)

    assert_equal "$5 CAD", Money.ca_dollar(570).format([:no_cents, :with_currency])
    assert_equal "$5 CAD", Money.ca_dollar(570).format(:no_cents, :with_currency)
    assert_equal "$390", Money.ca_dollar(39000).format(:no_cents)

    assert_equal "$5.70 <span class=\"currency\">CAD</span>", Money.ca_dollar(570).format([:html, :with_currency])
  end
  
  def test_format_zero
    assert_equal '$0.00', Money.empty.format
  end
  
  def test_custom_format_zero
    Money.zero = 'zilch'
    assert_equal 'zilch', Money.empty.format
    Money.zero = nil
  end
  
  def test_to_precision
    assert_equal Money.new(500, 'USD', 3), Money.new(50, 'USD', 2).to_precision(3)
    assert_equal Money.new(56, 'USD', 2), Money.new(555, 'USD', 3).to_precision(2)
    assert_equal Money.new(56, 'USD', 2), Money.new(56, 'USD', 2).to_precision(2)
  end
  
  def test_dollars
    assert_equal 5.75, 5.75.to_money.dollars
    assert_equal 5.755, Money.new(5755, 'USD', 3).dollars
  end
  
end