module Dirty
  module Hash

    def self.included(base)
      base.method_defined?(:regular_writer).tap do |defined|
        base.send :include, InstanceMethods
        unless defined
          base.send :alias_method, :_store, :store
          base.send :alias_method, :store, :regular_writer
          base.send :alias_method, :[]=, :store
          base.send :define_method, :update do |other|
            other.each{|key, value| store key, value}
          end
          base.send :alias_method, :merge!, :update
        end
      end
    end

    module InstanceMethods
      def initialize(constructor = {}, map_methods = false, restricted_keys = nil)
        constructor.each do |key, value|
          self[key] = value
        end
        if map_methods
          extend MethodMap
          dirty_map!
        end
        if restricted_keys
          restricted_keys.each{|key| self[correct_key(key, map_methods)] ||= nil}
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

      def regular_writer(key, value)
        validate_write!(key)
        original_value = changes.key?(key) ? was(key) : fetch(key, nil)
        if original_value == value
          changes.delete key
        else
          changes[key] = [original_value, value]
        end
        defined?(_store) ? _store(key, value) : super(key, value)
      end

      def delete(key)
        self[key] = nil
        super
      end

      def changes
        @changes ||= self.class.superclass.new
      end

      def changed?(key = nil, mapped = false)
        validate_read!(correct_key(key, mapped)) if !key.nil? && (mapped || restricted_keys?)
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

      def correct_key(key, mapped = false)
        mapped || is_a?(HashWithIndifferentAccess) ? key.to_s : key
      end

      def restricted_keys?
        !(@restricted_keys || []).empty?
      end

      def validate_read!(key)
        raise IndexError, "Invalid key: \"#{key}\"" unless (keys + changes.keys).include?(key)
      end

      def validate_write!(key)
        raise IndexError, "Invalid key: \"#{key}\"" unless @restricted_keys.nil? || @restricted_keys.empty? || @restricted_keys.include?(key)
      end

    end

  end
end