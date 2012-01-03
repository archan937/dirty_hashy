module Dirty
  module Attributes

    def self.included(base)
      base.extend ClassMethods
      base.send :include, InstanceMethods
      base.send :include, MethodMap
    end

    module ClassMethods
      def attrs(*names)
        @attrs = names.collect(&:to_s)
      end

      def attributes
        @attrs
      end
    end

    module InstanceMethods
      attr_reader :attributes

      def initialize
        @attributes = DirtyIndifferentHashy.new({}, true, self.class.attributes).tap do |hashy|
          dirty_map! hashy
          clean_up!
        end
      end

      def attributes=(other)
        attributes.replace other
      rescue IndexError => e
        e.message.match /"(.*)"/
        raise NoMethodError, "undefined method `#{$1}=' for #{self.inspect}"
      end
    end

  end
end