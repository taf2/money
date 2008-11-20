require File.dirname(__FILE__) + '/../../spec_helper'
require 'rubygems'
require 'active_record'
require 'money/rails'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => File.expand_path(File.dirname(__FILE__) + '/test.db' ))
ActiveRecord::Schema.suppress_messages do
  ActiveRecord::Schema.define do
    create_table :money_examples, :force => true do |t|
      t.integer :credit_amount_in_cents
      t.integer :debit_amount_in_cents
    end
  end
end

class MoneyExample < ActiveRecord::Base
  money :debit_amount
end

describe Money, "using the money declaration in an ActiveRecord model" do
  it "still allows dynamic finders to work the same as composed_of" do
    record = MoneyExample.create!(:debit_amount => 100.to_money)
    MoneyExample.find_by_debit_amount(0.to_money).should be_nil
    MoneyExample.find_by_debit_amount(100.to_money).should == record
  end
end