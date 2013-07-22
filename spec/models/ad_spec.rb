require "active_support/core_ext"

require_relative "../../lib/extensions/ad/expiration"
require_relative "../../lib/extensions/ad/type"
require_relative "../../lib/extensions/ad/status"

class Ad
  attr_accessor :status

  include Extensions::Ad::Expiration
  include Extensions::Ad::Type
  include Extensions::Ad::Status
end

describe Ad do
  subject { Ad.new }

  describe "expiration logic" do
    describe "#expires_at" do
      it "is a date a month away from creation date" do
        now = Time.now
        subject.stub(:created_at) { now }
        subject.expires_at.should == now + Ad::VALID_FOR.days
      end
    end

    describe "#closed?" do
      context "when it's created more than VALID_DAYS ago" do
        before { subject.stub(:created_at) { Time.now - (Ad::VALID_FOR + 1).days } }
        its(:closed?) { should be_true }
      end

      context "when it's created less than VALID_DAYS ago" do
        before { subject.stub(:created_at)  { Time.now - (Ad::VALID_FOR - 2).days } }
        its(:closed?) { should be_false }
      end
    end

  end

  describe "#supply?" do
    context "when ad is supply" do
      before { subject.stub(:ad_type) { Ad.type[:supply] } }
      its(:supply?) { should be_true }
    end

    context "when ad is not supply" do
      before { subject.stub(:ad_type) }
      its(:supply?) { should_not be_true }
    end
  end

  describe "#demand?" do
    context "when ad is demand" do
      before { subject.stub(:ad_type) { Ad.type[:demand] } }
      its(:demand?) { should be_true }
    end

    context "when ad is not demand" do
      before { subject.stub(:ad_type) }
      its(:demand?) { should_not be_true }
    end
  end

  describe "#set_status" do
    context "when supply" do
      before { subject.stub(:ad_type) { Ad.type[:supply] } }
      it "sets status to pending" do
        subject.set_status
        subject.status.should == Ad.status[:pending]
      end
    end

    context "when demand" do
      before { subject.stub(:ad_type) { Ad.type[:demand] } }
      it "sets status to active" do
        subject.set_status
        subject.status.should == Ad.status[:active]
      end
    end

    it "sets status to closed" do
      subject.stub(:ad_type)
      subject.set_status
      subject.status.should == Ad.status[:closed]
    end
  end
end
