module DirtyAttributes

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
      @attrs || []
    end
  end

  module InstanceMethods
    attr_reader :attributes

    def initialize
      attrs = self.class.attributes.inject({}){|h, a| h.merge({a => nil})}
      @attributes = DirtyHashy.new(attrs).tap do |hashy|
        dirty_map! hashy, attrs.keys
        clean_up!
      end
    end

    def attributes=(other)
      attributes.clear.merge! other
    end
  end

end