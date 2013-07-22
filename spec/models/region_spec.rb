require 'spec_helper'

describe Region do
  subject { Region.new }
  
  it "should respond to ads" do
    subject.respond_to?(:ads).should be_true
  end
end
