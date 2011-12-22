require "active_support/hash_with_indifferent_access"
require "dirty_hashy/version"
require "method_map"

class DirtyHashy < HashWithIndifferentAccess

  def self.new(constructor = {}, map_methods = false)
    super(constructor).tap do |instance|
      if map_methods
        instance.extend MethodMap
        instance.dirty_map!
      end
    end
  end

  alias :_regular_writer :regular_writer
  def regular_writer(key, value)
    original_value = changes.key?(key) ? was(key) : self[key]
    if original_value == value
      changes.delete key
    else
      changes[key] = [original_value, value]
    end
    _regular_writer key, value
  end

  def delete(key)
    self[key] = nil
    super
  end

  def changes
    @changes ||= HashWithIndifferentAccess.new
  end

  def changed?(key = nil)
    key.nil? ? !changes.empty? : changes.key?(key)
  end
  alias :dirty? :changed?

  def change(key)
    changes[key] if changed?(key)
  end

  def was(key)
    change(key).first if changed?(key)
  end

  def clean_up!
    changes.clear
    nil
  end

end