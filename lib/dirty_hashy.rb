require "dirty"
require "dirty_indifferent_hashy"
require "dirty_hashy/version"
require "method_map"

class DirtyHashy < Hash
  include Dirty::Hash
end