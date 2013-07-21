require 'spec_helper'

describe User do
  it "has name" do
    user = User.new do |u|
      u.first_name = "Bugs"
      u.last_name  = "Bunny"
    end

    user.name.should == "Bugs Bunny"
  end
end
