module Interop
  @cache = {}

  def self.import(id)
    if @cache.include?(id)
      puts "Cache hit #{id}"
      return @cache[id]
    end

    puts "Load #{id}"
    snapshot = Module.constants
    require id
    cleanly_load(Module.constants - snapshot)
  end

  def self.cleanly_load(targets)
    puts "Package definitions #{targets}"
    result = wrap_constants(targets)
    result.each_pair do |key, value|
      Object.send(:remove_const, key.to_sym) unless key.include?('::')
    end

    result
  end

  def self.wrap_constants(new, result={})
    if new.length == 0
      return result
    end

    str = new.pop().to_s
    const = eval str
    if const.nil?
      return wrap_constants(new, result)
    end

    if const.respond_to? :constants
      # TODO(ari): Handle circular references!
      children = const.constants.map {|child| "#{str}::#{child.to_s}"}
      new += children
    end

    result[str] = const.class == Module ? Class.new.extend(const) : const
    return wrap_constants(new, result)
  end
end
