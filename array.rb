class Array
  # call-seq:
  #    array.shuffle!(random: Random) -> array
  #
  # Shuffles the elements of +self+ in place.
  #    a = [1, 2, 3] #=> [1, 2, 3]
  #    a.shuffle!    #=> [2, 3, 1]
  #    a             #=> [2, 3, 1]
  #
  # The optional +random+ argument will be used as the random number generator:
  #    a.shuffle!(random: Random.new(1))  #=> [1, 3, 2]
  def shuffle!(random: Random)
    Primitive.rb_ary_shuffle_bang(random)
  end

  # call-seq:
  #    array.shuffle(random: Random) -> new_ary
  #
  # Returns a new array with elements of +self+ shuffled.
  #    a = [1, 2, 3] #=> [1, 2, 3]
  #    a.shuffle     #=> [2, 3, 1]
  #    a             #=> [1, 2, 3]
  #
  # The optional +random+ argument will be used as the random number generator:
  #    a.shuffle(random: Random.new(1))  #=> [1, 3, 2]
  def shuffle(random: Random)
    Primitive.rb_ary_shuffle(random)
  end

  # call-seq:
  #    array.sample(random: Random) -> object
  #    array.sample(n, random: Random) -> new_ary
  #
  # Returns random elements from +self+.
  #
  # When no arguments are given, returns a random element from +self+:
  #    a = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  #    a.sample # => 3
  #    a.sample # => 8
  # If +self+ is empty, returns +nil+.
  #
  # When argument +n+ is given, returns a new \Array containing +n+ random
  # elements from +self+:
  #    a.sample(3) # => [8, 9, 2]
  #    a.sample(6) # => [9, 6, 10, 3, 1, 4]
  # Returns no more than <tt>a.size</tt> elements
  # (because no new duplicates are introduced):
  #    a.sample(a.size * 2) # => [6, 4, 1, 8, 5, 9, 10, 2, 3, 7]
  # But +self+ may contain duplicates:
  #    a = [1, 1, 1, 2, 2, 3]
  #    a.sample(a.size * 2) # => [1, 1, 3, 2, 1, 2]
  # The argument +n+ must be a non-negative numeric value.
  # The order of the result array is unrelated to the order of +self+.
  # Returns a new empty \Array if +self+ is empty.
  #
  # The optional +random+ argument will be used as the random number generator:
  #    a = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  #    a.sample(random: Random.new(1))     #=> 6
  #    a.sample(4, random: Random.new(1))  #=> [6, 10, 9, 2]
  def sample(n = (ary = false), random: Random)
    if Primitive.mandatory_only?
      # Primitive.cexpr! %{ rb_ary_sample(self, rb_cRandom, Qfalse, Qfalse) }
      Primitive.ary_sample0
    else
      # Primitive.cexpr! %{ rb_ary_sample(self, random, n, ary) }
      Primitive.ary_sample(random, n, ary)
    end
  end

  def first n = unspecified = true
    if Primitive.mandatory_only?
      Primitive.attr! :leaf
      Primitive.cexpr! %q{ ary_first(self) }
    else
      if unspecified
        Primitive.cexpr! %q{ ary_first(self) }
      else
        Primitive.cexpr! %q{  ary_take_first_or_last_n(self, NUM2LONG(n), ARY_TAKE_FIRST) }
      end
    end
  end

  def last n = unspecified = true
    if Primitive.mandatory_only?
      Primitive.attr! :leaf
      Primitive.cexpr! %q{ ary_last(self) }
    else
      if unspecified
        Primitive.cexpr! %q{ ary_last(self) }
      else
        Primitive.cexpr! %q{ ary_take_first_or_last_n(self, NUM2LONG(n), ARY_TAKE_LAST) }
      end
    end
  end
end
