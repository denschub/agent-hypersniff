# frozen_string_literal: true

class DataLoader
  def self.sniffers
    YAML.load_file("./data/ua-sniffers.yml").deep_symbolize_keys
  end

  def self.user_agents
    user_agents = {}
    Dir.children("./data/user-agents/").sort.each do |filename|
      basename = filename.delete_suffix(".yml")
      user_agents[basename] = YAML.load_file(File.join("./data/user-agents/", filename))
    end
    user_agents.deep_symbolize_keys
  end
end
