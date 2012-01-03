require "active_support/hash_with_indifferent_access"

class DirtyIndifferentHashy < HashWithIndifferentAccess
  include Dirty::Hash
end