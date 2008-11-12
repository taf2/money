require File.dirname(__FILE__) + '/../spec_helper'

describe "NoExchangeBank" do
  
  before do
    @bank = NoExchangeBank.new
  end
  
  it "exchange" do    
    lambda {@bank.exchange(Money.us_dollar(100), "CAD")}.should raise_error
  end

  it "work if no exchange is required" do
    lambda {@bank.exchange(Money.ca_dollar(100), "CAD")}.should_not raise_error
  end
  
end
