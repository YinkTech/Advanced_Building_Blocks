# rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

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
      my_each { |item| return true unless args[0] == item }
    elsif block_given?
      my_each { |item| return false unless yield(item) }
    elsif args.instance_of?(Class)
      my_each { |item| return false if item != args }
    elsif args.instance_of?(Regexp)
      my_each { |item| return false unless args.match(item) }
    else
      my_each { |item| return false if item == args }
    end
    false
  end

  def my_any?(*args)
    if !args[0].nil?
      my_each { |item| return false if args[0] == item }
    elsif block_given?
      my_each { |item| return true if item }
    elsif args.instance_of?(Class)
      my_each { |_item| return true if items.instance_of?(args) == args }
    elsif args.instance_of?(Regexp)
      my_each { |item| return true if args.match(item) }
    else
      my_each { |item| return true if item == args }
    end
    true
  end

  def my_none?(args = nil, &block)
    my_any?(args, &block)
    if block_given?
      my_each { |item| return false if yield item }
    elsif args.nil?
      my_each { |item| return false if item }
    elsif args.instance_of?(Class)
      my_each { |item| return false if item.instance_of?(args) }
    elsif args.instance_of?(Regexp)
      my_each { |item| return false if args.match(item) }
    else
      my_each { |item| return false if item == args }
    end
    false
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

    arr = [].to_a
    if arg.nil? && block_given?
      my_each do |e|
        arr << block.call(e)
      end
    else
      arr
    end
  end

  def my_inject(initial = nil, &block)
    return to_a[1..-1].my_inject(first, &block) if initial.nil?

    accumulator = initial
    my_each { |item| accumulator = yield accumulator, item } if block_given?
    accumulator
  end
end

# rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

def multiply_els(arr)
  arr.inject { |memo, e| memo * e }
end

p multiply_els([2, 4, 5])
