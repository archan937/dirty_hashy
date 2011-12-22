# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Paul Engel"]
  gem.email         = ["paul.engel@holder.nl"]
  gem.description   = %q{Dirty tracking within hashes with indifferent access or objects as it is expected to be!}
  gem.summary       = %q{Dirty tracking within hashes with indifferent access or objects as it is expected to be!}
  gem.homepage      = "https://github.com/archan937/dirty_hashy"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "dirty_hashy"
  gem.require_paths = ["lib"]
  gem.version       = "0.1.0"

  gem.add_dependency "activesupport", ">= 3.0.0"
end