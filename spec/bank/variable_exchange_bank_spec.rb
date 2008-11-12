require File.dirname(__FILE__) + '/../spec_helper'

describe "VariableExchangeBank" do
  
  before do
    @bank = VariableExchangeBank.new
  end
  
  it "unknown exchange" do    
    lambda { @bank.exchange(Money.us_dollar(100), "CAD") }.should raise_error
  end
    
  it "exchange" do
    @bank.add_rate("USD", "CAD", 1.24515)
    @bank.add_rate("CAD", "USD", 0.803115)
    @bank.exchange(Money.us_dollar(100), "CAD").should == Money.ca_dollar(124)
    @bank.exchange(Money.ca_dollar(100), "USD").should == Money.us_dollar(80)
  end
  
  it "reduce with other precision" do
    @bank.add_rate("CAD", "USD", 0.803115)
    @bank.exchange(Money.new(1000, 'CAD', 3), "USD").should == Money.new(803, "USD", 3)
  end
  
end
