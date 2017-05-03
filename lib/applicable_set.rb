require "applicable_set/version"

class Set
  JUDGEMENT = ->(obj, set) { obj.is_a?(Set) ? obj.applicable?(set) : set.include?(obj) }

  def applicable?(set)
    set.subset?(self)
  end
end

class And < Set
  def applicable?(set)
    all? { |cond| JUDGEMENT.(cond, set) }
  end
end

class Or < Set
  def applicable?(set)
    any? { |cond| JUDGEMENT.(cond, set) }
  end
end

class Not < Set
  def applicable?(set)
    none? { |cond| JUDGEMENT.(cond, set) }
  end
end
