# rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

module Enumerable
  def my_each(&block)
    return enum_for unless block_given?

    each(&block)
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

  def my_all?(args = nil)
    return true if (instance_of?(Array) && count.zero?) || (!block_given? &&
     args.nil? && !include?(nil))
    return false unless block_given? || !args.nil?

    item = true
    if instance_of?(Array)
      my_each do |a|
        if block_given?
          item = false unless yield(a)
        elsif args.instance_of?(Regexp)
          item = false unless a.match(args)
        elsif args.class <= Numeric
          item = false unless a == args
        else
          item = false unless a.class <= args
        end
        break unless item
      end
    else
      my_each do |key, value|
        item = false unless yield(key, value)
      end
    end
    item
  end

  def my_any?(args = nil)
    if block_given?
      my_each { |item| return true if yield item }
    elsif args.nil?
      my_each { |item| return true if item }
    elsif args.instance_of?(Regexp)
      my_each { |item| return true if item.match(args) }
    elsif args.instance_of?(Class)
      my_each { |item| return true if item.class != args || item.class.superclass == args }
    else
      my_each { |item| return true if args == item }
    end
    false
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
    arr = []
    each do |e|
      arr <<
        block.call(e)
    end
    arr
  end

  def my_inject(args = nil)
    sym = to_enum
    item = args.nil? ? sym.next : args

    if block_given?
      loop do
        item = yield(item, sym.next)
      end
    else
      raise LocalJumpError, 'no block given'
    end
    item
  end
end

# rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

def multiply_els(arr)
  arr.my_inject { |memo, e| memo * e }
end

#p multiply_els([2, 4, 5])
 # puts '(1,2,3)'.my_each
