require_relative "../../lib/extensions/user/naming"

class User
  include Extensions::User::Naming
end

describe User do
  it "has name" do
    user = User.new
    user.stub(:first_name) { "Bugs" }
    user.stub(:last_name) { "Bunny" }

    user.name.should == "Bugs Bunny"
  end
end
