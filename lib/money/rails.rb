require 'money'

module ActiveRecord #:nodoc:
  module Acts #:nodoc:
    module Money #:nodoc:
      def self.included(base) #:nodoc:
        base.extend ClassMethods
      end

      module ClassMethods
        
        def money(name, options = {})
          options = {:cents => "#{name}_in_cents".to_sym}.merge(options)
          mapping = [[options[:cents].to_s, 'cents']]
          mapping << [options[:currency].to_s, 'currency'] if options[:currency]
          composed_of name, :class_name => 'Money', :mapping => mapping, :allow_nil => true do |m|
            m.to_money
          end
            
          define_method "#{name}_with_blank=" do |value|
            send("#{name}_without_blank=", value) unless value.blank?
          end
          alias_method_chain "#{name}=", :blank
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, ActiveRecord::Acts::Money