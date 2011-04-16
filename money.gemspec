Gem::Specification.new do |s|
  s.name = 'money'
  s.version = '1.7.7'
  s.summary = "Class aiding in the handling of Money."
  s.description = 'Class aiding in the handling of Money and Currencies. It supports easy pluggable bank objects for customized exchange strategies. Can be used as composite in ActiveRecord tables.'

  s.files = %w(
    README
    MIT-LICENSE
    lib/money.rb
    lib/money/core_extensions.rb
    lib/money/bank/no_exchange_bank.rb
    lib/money/bank/variable_exchange_bank.rb
    lib/money/rails.rb
  )

  s.require_path = 'lib'
  s.authors = ["Daniel Morrison", "Brandon Keepers", "Tobias Luetke"]
  s.email = "info@collectiveidea.com"
  s.homepage = "http://github.com/collectiveidea/money"
end
