module MethodMap

  def dirty_map!(mapped = nil)
    @mapped = mapped || self
    map_method(:changes)
    map_method(:dirty?)
    map_method(:changed?)
    map_method(:clean_up!)
    map_method(/^([\w_]+)_changed\?$/, :changed?, true)
    map_method(/^([\w_]+)_change$/, :change, true)
    map_method(/^([\w_]+)_was$/, :was, true)
    map_method(/(^[\w_]+)=$/, :[]=)
    map_method(/(^[\w_]+)$/, :[], true)
  end

  def map_method(pattern, method_or_proc = nil, args = nil)
    regex = pattern.is_a?(Regexp) ? pattern : Regexp.new("^#{Regexp.escape(pattern.to_s)}$")
    method_map[regex] = {:method_or_proc => (method_or_proc || pattern), :args => args}
  end

  def method_missing(method, *args)
    if m = match_method(method)
      begin
        return @mapped.send *(m + args)
      rescue IndexError; end
    end
    super
  end

private

  def method_map
    @method_map ||= {}
  end

  def match_method(method)
    method_map.each do |pattern, spec|
      method_or_proc = spec[:method_or_proc]
      if method.to_s.match pattern
        m = method_or_proc.is_a?(Proc) ? method_or_proc.call($1 || method) : method_or_proc
        return [m, $1, spec[:args]].compact if m
      end
    end
    nil
  end

end