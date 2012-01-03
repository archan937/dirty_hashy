require "active_support/hash_with_indifferent_access"
require "dirty/hash"
require "dirty_hashy/version"
require "dirty_attributes"
require "method_map"

class DirtyHashy < HashWithIndifferentAccess

  def initialize(constructor = {}, map_methods = false, restricted_keys = nil)
    super constructor
    extend Dirty::Hash
    dirty! map_methods, restricted_keys
  end

end