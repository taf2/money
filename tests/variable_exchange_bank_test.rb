$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'test/unit'
require 'money'

class VariableExchangeBankTest < Test::Unit::TestCase
  
  def setup
    @bank = VariableExchangeBank.new
  end
  
  def test_unknown_exchange    
    assert_raise(Money::MoneyError) do
      @bank.reduce(Money.us_dollar(100), "CAD")
    end    
  end
    
  def test_exchange
    @bank.add_rate("USD", "CAD", 1.24515)
    @bank.add_rate("CAD", "USD", 0.803115)
    assert_equal Money.ca_dollar(124), @bank.reduce(Money.us_dollar(100), "CAD")
    assert_equal Money.us_dollar(80), @bank.reduce(Money.ca_dollar(100), "USD")
  end
  
  def test_reduce_with_other_precision
    @bank.add_rate("CAD", "USD", 0.803115)
    assert_equal Money.new(803, "USD", 3), @bank.reduce(Money.new(1000, 'CAD', 3), "USD")
  end
  
end
