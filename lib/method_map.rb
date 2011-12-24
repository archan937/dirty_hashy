module MethodMap

  def dirty_map!(mapped = nil, restricted_keys = nil)
    @mapped = mapped || self
    @restricted_keys = (restricted_keys || []).collect(&:to_s)
    map_method(:changes)
    map_method(:dirty?)
    map_method(:changed?)
    map_method(:clean_up!)
    map_method(/^([\w_]+)_changed\?$/, Proc.new{ |match| :changed? if map_key? match })
    map_method(/^([\w_]+)_change$/   , Proc.new{ |match| :change   if map_key? match })
    map_method(/^([\w_]+)_was$/      , Proc.new{ |match| :was      if map_key? match })
    map_method(/(^[\w_]+)=$/         , Proc.new{ |match| :[]=      if accept_key? match })
    map_method(/(^[\w_]+)$/          , Proc.new{ |match| :[]       if map_key? match })
  end

  def map_method(pattern, method_or_proc = nil)
    regex = pattern.is_a?(Regexp) ? pattern : Regexp.new("^#{Regexp.escape(pattern.to_s)}$")
    method_map[regex] = method_or_proc || pattern
  end

  def method_missing(method, *args)
    if m = match_method(method)
      @mapped.send *(m + args)
    else
      super
    end
  end

private

  def map_key?(key)
    (@mapped.keys + @mapped.changes.keys).include?(key.to_s)
  end

  def accept_key?(key)
    @restricted_keys.empty? || @restricted_keys.include?(key.to_s)
  end

  def method_map
    @method_map ||= {}
  end

  def match_method(method)
    method_map.each do |pattern, method_or_proc|
      if method.to_s.match pattern
        m = method_or_proc.is_a?(Proc) ? method_or_proc.call($1 || method) : method_or_proc
        return [m, $1].compact if m
      end
    end
    nil
  end

end