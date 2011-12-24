require "active_support/hash_with_indifferent_access"
require "dirty_hashy/version"
require "dirty_attributes"
require "method_map"

class DirtyHashy < HashWithIndifferentAccess

  def initialize(constructor = {}, map_methods = false, restricted_keys = nil)
    super constructor
    if map_methods
      extend MethodMap
      dirty_map!
    end
    if restricted_keys
      restricted_keys.each{|key| self[key] ||= nil}
      @restricted_keys = keys
    end
  end

  def replace(other)
    clear
    merge! other
  end

  def clear
    keys.each{|key| delete key}
  end

  def [](key, mapped = false)
    validate_read!(key) if mapped || restricted_keys?
    super(key)
  end

  alias :_regular_writer :regular_writer
  def regular_writer(key, value)
    validate_write!(key)
    original_value = changes.key?(key) ? was(key) : fetch(key, nil)
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

  def changed?(key = nil, mapped = false)
    validate_read!(key) if !key.nil? && (mapped || restricted_keys?)
    key.nil? ? !changes.empty? : changes.key?(key)
  end
  alias :dirty? :changed?

  def change(key, mapped = false)
    changes[key] if changed?(key, mapped)
  end

  def was(key, mapped = false)
    change(key).first if changed?(key, mapped)
  end

  def clean_up!
    changes.clear
    nil
  end

private

  def restricted_keys?
    !(@restricted_keys || []).empty?
  end

  def validate_read!(key)
    raise IndexError, "Invalid key: \"#{key}\"" unless (keys + changes.keys).include?(key.to_s)
  end

  def validate_write!(key)
    raise IndexError, "Invalid key: \"#{key}\"" unless @restricted_keys.nil? || @restricted_keys.empty? || @restricted_keys.include?(key.to_s)
  end

end