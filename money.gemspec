Gem::Specification.new do |s|
  s.name = 'money'
  s.version = '1.7.2'
  s.summary = "Class aiding in the handling of Money."
  s.description = 'Class aiding in the handling of Money and Currencies. It supports easy pluggable bank objects for customized exchange strategies. Can be used as composite in ActiveRecord tables.'
  s.has_rdoc = true

  s.files = %w(
    README
    MIT-LICENSE
    lib/bank/no_exchange_bank.rb
    lib/bank/variable_exchange_bank.rb
    lib/money
    lib/money/core_extensions.rb
    lib/money/money.rb
    lib/money.rb
    lib/support
    lib/support/cattr_accessor.rb
  )

  s.require_path = 'lib'
  s.author = "Tobias Luetke"
  s.email = "tobi@leetsoft.com"
  s.homepage = "http://leetsoft.com/rails/money"  
end
