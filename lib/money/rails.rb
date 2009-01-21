require 'money'

module ActiveRecord #:nodoc:
  module Acts #:nodoc:
    module Money #:nodoc:
      def self.included(base) #:nodoc:
        base.extend ClassMethods
      end

      module ClassMethods
        
        def money(name, options = {})
          options = {:precision => 2, :cents => "#{name}_in_cents".to_sym}.merge(options)
          mapping = [options[:cents], 'cents']
          mapping << [options[:currency].to_s, 'currency'] if options[:currency]
          composed_of name, :class_name => 'Money', :mapping => mapping, :allow_nil => true,
            :converter => lambda{ |m| m.to_money(options[:precision]) }

          define_method "#{name}" do
            cents = read_attribute(mapping.first)
            ::Money.new(read_attribute(mapping.first), (options[:currency] || 'USD'), options[:precision]) if cents
          end

          define_method "#{name}=" do |amount|
            if amount.is_a?(::Money)
              write_attribute mapping.first, amount.to_precision(options[:precision]).cents
            elsif amount.blank?
              write_attribute mapping.first, nil
            else
              write_attribute mapping.first, amount.to_money(options[:precision]).cents
            end
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, ActiveRecord::Acts::Money
