require 'spec_helper'

describe Reply do
  before { @it = Reply.new }
  describe "validations" do
    it "validate that a content is not empty" do
      @it.content = "             "
      expect(@it).to be_invalid
    end
  end
end
