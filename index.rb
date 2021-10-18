module Enumerable
  def my_each
    i = 0
    while self[i]
      yield(self[i])
      i += 1
    end
  end

  def my_each_with_index
    my_each { |e| yield(e, index(e)) }
  end

  def my_select
    result = []
    each do |e|
      result << e if yield(e)
    end
    result
  end

  def my_all?(*args)
    if !args[0].nil?
      my_each { |item| return false unless args[0] === item }
    elsif block_given?
      my_each { |item| return false unless yield(item) }
    elsif args.instance_of?(Class)
      my_each { |item| return false unless yield(item) != args }
    elsif args.instance_of?(Regexp)
      my_each { |item| return false unless args.match(item) }
    else
      my_each { |item| return false unless item }
    end
    true
  end

  def my_any?(*args)
    if !args[0].nil?
      my_each { |item| return true if args[0] === item }
    elsif block_given?
      my_each { |item| return true if item }
    elsif args.instance_of?(Class)
      my_each { |item| return true if yield(item) == args }
    elsif args.instance_of?(Regexp)
      my_each { |item| return true if args.match(item) }
    else
      my_each { |item| return true if item == args }
    end
    false
  end

  def my_none?(arg = nil, &block)
    !my_any?(arg, &block)
    if block_given?
      my_each { |item| return false if yield item }
    elsif args.nil?
      my_each { |item| return false if item }
    elsif args.instance_of?(Class)
      my_each { |item| return false if item.is_a?(args) }
    elsif args.instance_of?(Regexp)
      my_each { |item| return false if args.match(item) }
    else
      my_each { |item| return false if item == args }
    end
    true
  end

  def my_count(param = nil)
    count = 0

    if !param.nil?
      my_each { |item| count += 1 if item == param }
    elsif block_given?
      my_each { |item| count += 1 if yield(item) }
    else
      my_each { count += 1 }
    end
    count
  end

  def my_map(&block)
    return count unless block_given?

    arr = []
    my_each do |e|
      arr << block.call(e)
    end
    arr
  end

  def my_inject(param1 = nil, param2 = nil)
    arr = is_a?(Array) ? self : to_a
    sym = param1 if param1.is_a?(Symbol) || param1.is_a?(String)
    acc = param1 if param1.is_a? Integer

    case param1
    when Integer
      if param2.is_a?(Symbol) || param2.is_a?(String)
        sym = param2
      elsif !block_given?
        raise "#{param2} is not a symbol nor a string"
      end
    when Symbol, String
      raise "#{param2} is not a symbol nor a string" if !param2.is_a?(Symbol) && !param2.nil?

      raise "undefined method `#{param2}' for :#{param2}:Symbol" if param2.is_a?(Symbol) && !param2.nil?
    end

    if sym
      arr.my_each { |curr| acc = acc ? acc.send(sym, curr) : curr }
    elsif block_given?
      arr.my_each { |curr| acc = acc ? yield(acc, curr) : curr }
    else
      raise 'no block given'
    end
    acc
  end
end

def multiply_els(arr)
  arr.my_inject { |memo, e| memo * e }
end
p multiply_els([2, 4, 5])