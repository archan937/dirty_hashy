begin
  require "active_support/hash_with_indifferent_access"
rescue LoadError
  require "active_support/core_ext/hash/indifferent_access"
end

class DirtyIndifferentHashy < HashWithIndifferentAccess
  include Dirty::Hash
end