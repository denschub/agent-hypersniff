# frozen_string_literal: true

class Counter
  def self.noses(sniffers)
    sniffers.length
  end

  def self.sniffers(sniffers)
    sniffers.map {|nose| nose[1].length }.sum
  end

  def self.user_agents(user_agents)
    user_agents.length
  end
end
