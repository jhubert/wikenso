class WelcomePage < ActiveRecord::Base
  def self.latest
    last
  end
end
