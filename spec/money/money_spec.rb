require File.dirname(__FILE__) + '/../spec_helper'

describe "Money" do
  
  before do
    
    @can1  = Money.ca_dollar(100)
    @can2  = Money.ca_dollar(200)
    @can3  = Money.ca_dollar(300)
    @us1   = Money.us_dollar(100)
    
    Money.bank = NoExchangeBank.new
    Money.default_currency = "USD"
    
  end
  
  it "sanity" do

    @can1.should == @can1
    (@can1 < @can2).should be_true
    (@can3 > @can2).should be_true
    [@can1, @can2, @can3].should == [@can1, @can2, @can3]
    [@can3, @can2, @can1].sort.should == [@can1, @can2, @can3]
    [@can3, @can2, @can1].should_not == [@can1, @can2, @can3]
    ([@can1, @can2, @can3] & [@can1]).should == [@can1]

    ([@can1] | [@can2]).should == [@can1, @can2]

    
    (@can1 + @can2).should == @can3
    (@can2 - @can1).should == @can1
    
    (Money.ca_dollar(10) + Money.ca_dollar(90) + Money.ca_dollar(500) - Money.ca_dollar(100)).should == Money.ca_dollar(500)
      
  end
  
  it "default currency" do
    
    "USD".should == Money.new(100).currency
    Money.default_currency = "CAD"
    "CAD".should == Money.new(100).currency
  end
  
  it "default exchange" do   
    lambda {Money.us_dollar(100).exchange_to("CAD")}.should raise_error
  end
  
  it "zero" do
    Money.empty.should be_zero
    Money.ca_dollar(1).should_not be_zero
    Money.ca_dollar(-1).should_not be_zero
  end
  
  it "real exchange" do   
    Money.bank = VariableExchangeBank.new
    Money.bank.add_rate("USD", "CAD", 1.24515)
    Money.bank.add_rate("CAD", "USD", 0.803115)
    Money.ca_dollar(124).should == Money.us_dollar(100).exchange_to("CAD")
    Money.us_dollar(80).should == Money.ca_dollar(100).exchange_to("USD")
  end
    
  it "multiply" do    
    (Money.ca_dollar(100) * 55).should == Money.ca_dollar(5500)
    (Money.ca_dollar(100) * 1.50).should == Money.ca_dollar(150)
    (Money.ca_dollar(100) * 0.50).should == Money.ca_dollar(50)
  end
  
  it "multiply with precision" do
    (Money.new(504, 'USD', 3) * 2).should == Money.new(1008, 'USD', 3)
  end
  
  it "divide" do
    (Money.ca_dollar(5500) / 55).should == Money.ca_dollar(100)
    (Money.ca_dollar(200) / 2).should == Money.ca_dollar(100)
  end

  it "divide with other precision" do
    (Money.new(5500, 'USD', 3) / 55).should == Money.new(100, 'USD', 3)
    (Money.new(200, 'USD', 3) / 2).should == Money.new(100, 'USD', 3)
  end
  
  it "add with other precision" do
    (Money.new(30, 'USD', 2) + Money.new(700, 'USD', 3)).should == Money.new(1000, 'USD', 3)
  end
  
  it "subtract with other precision" do
    (Money.new(50, 'USD', 2) - Money.new(50, 'USD', 3)).should == Money.new(450, 'USD', 3)
  end
  
  it "negative" do
    (-Money.new(43, 'CAD', 2)).should == Money.new(-43, 'CAD', 2)
    (-Money.new(2979, 'CAD', 3)).should == Money.new(-2979, 'CAD', 3)
  end
  
  it "empty can exchange currency" do
    Money.bank = VariableExchangeBank.new
    Money.bank.add_rate("CAD", "USD", 1)
    Money.bank.add_rate("USD", "CAD", 1)
    (Money.empty('USD') + Money.ca_dollar(100)).should == Money.us_dollar(100)
    (Money.ca_dollar(100) + Money.empty('USD')).should == Money.ca_dollar(100)
    
    (Money.empty('USD') - Money.ca_dollar(100)).should == Money.us_dollar(-100)
    (Money.ca_dollar(-100) - Money.empty('USD')).should == Money.ca_dollar(-100)
  end
  
  it "to s" do
    @can1.to_s.should == "1.00"
    Money.ca_dollar(39050).to_s.should == "390.50"
  end
  
  it "to_s with other precision" do
    Money.new(505, 'USD', 3).to_s.should == "0.505"
    Money.new(4, 'USD', -3).to_s.should == "4"
    Money.new(4, 'USD', -3).to_s(0).should == "4000"
    Money.new(505, 'USD', 3).to_s(2).should == "0.51"
    Money.new(504, 'USD', 3).to_s(2).should == "0.50"
    Money.new(1001, 'USD', 3).to_s(2).should == "1.00"
  end
  
  it "substract from zero" do
   (Money.empty - (12.to_money)).should == -12.to_money
  end
  
  it "formatting" do
    @can1.format.should == "$1.00"
    @can1.format(:with_currency).should == "$1.00 CAD"

    @can1.format(:no_cents).should == "$1"
    Money.ca_dollar(570).format(:no_cents).should == "$5"

    Money.ca_dollar(570).format([:no_cents, :with_currency]).should == "$5 CAD"
    Money.ca_dollar(570).format(:no_cents, :with_currency).should == "$5 CAD"
    Money.ca_dollar(39000).format(:no_cents).should == "$390"

    Money.ca_dollar(570).format([:html, :with_currency]).should == "$5.70 <span class=\"currency\">CAD</span>"
  end
  
  it "format zero" do
    Money.empty.format.should == '$0.00'
  end
  
  it "custom format zero" do
    Money.zero = 'zilch'
    Money.empty.format.should == 'zilch'
    Money.zero = nil
  end
  
  it "to precision" do
    Money.new(50, 'USD', 2).to_precision(3).should == Money.new(500, 'USD', 3)
    Money.new(555, 'USD', 3).to_precision(2).should == Money.new(56, 'USD', 2)
    Money.new(56, 'CAD', 2).to_precision(2).should == Money.new(56, 'CAD', 2)
  end
  
  it "dollars" do
    5.75.to_money.to_f.should == 5.75
    Money.new(5755, 'USD', 3).to_f.should == 5.755
  end
  
end