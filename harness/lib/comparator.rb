# frozen_string_literal: true

class Comparator
  def self.compare(type, expected, actual)
    return case type
    when :browser
      Comparator.compare_browser(expected, actual)
    when :version
      Comparator.compare_version(expected, actual)
    when :os
      Comparator.compare_os(expected, actual)
    when :isMobile
      Comparator.compare_isMobile(expected, actual)
    end
  end

  def self.compare_browser(expected, actual)
    result = :"n/a"
    unless actual == "n/a"
      if actual.include? expected
        result = :pass
      else
        result = :fail
      end
    end

    {
      result: result,
      expected: expected,
      actual: actual
    }
  end

  def self.compare_version(expected, actual)
    result = :"n/a"
    unless actual == "n/a"
      if actual.start_with? expected
        result = :pass
      else
        result = :fail
      end
    end

    {
      result: result,
      expected: expected,
      actual: actual
    }
  end

  def self.compare_os(expected, actual)
    result = :"n/a"
    unless actual == "n/a"
      if actual.include? expected
        result = :pass
      else
        result = :fail
      end
    end

    {
      result: result,
      expected: expected,
      actual: actual
    }
  end

  def self.compare_isMobile(expected, actual)
    result = :"n/a"
    unless actual == "n/a"
      if actual == expected
        result = :pass
      else
        result = :fail
      end
    end

    {
      result: result,
      expected: expected,
      actual: actual
    }
  end
end
