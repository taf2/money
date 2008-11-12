require File.dirname(__FILE__) + '/../spec_helper'

describe "CoreExtensions" do

  before do
  end

  it "numeric conversion" do
    100.to_money.should == Money.new(10000)
    100.38.to_money.should == Money.new(10038)
    -100.to_money.should == Money.new(-10000)
  end

  it "numeric conversion with precision" do
     1.to_money(3).should == Money.new(1000, Money.default_currency, 3)
  end
    
  it "string conversion" do
    "$1".to_money.should == Money.new(100)
    "$1.00".to_money.should == Money.new(100)
    "$1.37".to_money.should == Money.new(137)
    "CAD $1.00".to_money.should == Money.new(100, 'CAD')
    "-100".to_money.should == Money.new(-10000)
    "4.10".to_money.should == Money.new(410)
  end
  
  it "string conversion with commas" do
    '$1,234.56'.to_money.should == Money.new(123456)
  end
  
  it "string with other precision" do
    '5'.to_money.should == Money.new(500, 'USD', 2)
    '5.0'.to_money.should == Money.new(500, 'USD', 2)
    '5.00'.to_money.should == Money.new(500, 'USD', 2)
    '5.055'.to_money.should == Money.new(5055, 'USD', 3)
    '5.055'.to_money(2).should == Money.new(506, 'USD', 2)
  end
  
  it "float conversion with precision" do
    5.0.to_money.should == Money.new(500, 'USD', 2)
    5.00.to_money.should == Money.new(500, 'USD', 2)
    5.055.to_money.should == Money.new(5055, 'USD', 3)
    5.055.to_money(2).should == Money.new(506, 'USD', 2)
  end
  
  it "should raise and error when called on nil" do
    lambda {nil.to_money}.should raise_error
  end

end