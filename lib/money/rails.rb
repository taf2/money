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
          args = [name, {:class_name => 'Money', :mapping => mapping, :converter => lambda{|m| m.to_money}}]
          begin
            composed_of(*args)
          rescue
            converter_block = args.last.delete(:converter)
            composed_of(*args, &converter_block)
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, ActiveRecord::Acts::Money