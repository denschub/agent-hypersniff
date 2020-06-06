# frozen_string_literal: true

class Hash
  def self.tree
    new { |hash, key| hash[key] = tree }
  end
end

def print_char(str)
  print str
  $stdout.flush
end
