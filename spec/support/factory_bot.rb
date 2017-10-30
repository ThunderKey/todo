module FactoryBot
  @position_cache = {}
  def self.position_cache
    @position_cache
  end

  def self.next_position_for user
    position_cache[user] ||= -1
    position_cache[user] += 1
  end
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:each) do
    FactoryBot.reload
    FactoryBot.position_cache.clear
  end
end
