Gem::Specification.new do |s|
  s.name = 'money'
  s.version = '1.7.2'
  s.summary = "Class aiding in the handling of Money."
  s.description = ['Class aiding in the handling of Money and Currencies.',
                   'It supports easy pluggable bank objects for customized exchange strategies.',
                   'Can be used as composite in ActiveRecord tables.'].join('\n')
  s.has_rdoc = true

  s.files = %w(README MIT-LICENSE) + Dir['lib/**/*']  

  s.require_path = 'lib'
  s.autorequire  = 'money'
  s.author = "Tobias Luetke"
  s.email = "tobi@leetsoft.com"
  s.homepage = "http://leetsoft.com/rails/money"  
end