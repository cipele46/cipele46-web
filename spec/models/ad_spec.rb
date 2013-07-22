require 'spec_helper'

describe Ad do
  subject { Ad.new }

  describe "#expires_at" do
    it "is a date a month away from creation date" do
      now = Time.now
      subject.created_at = now
      subject.expires_at.should == now + Ad::VALID_FOR.days
    end
  end

  describe "#supply?" do
    context "when ad is supply" do
      before { subject.ad_type = Ad::TYPES[:supply] }
      its(:supply?) { should be_true }
    end

    context "when ad is not supply" do
      its(:supply?) { should_not be_true }
    end
  end

  describe "#demand?" do
    context "when ad is demand" do
      before { subject.ad_type = Ad::TYPES[:demand] }
      its(:demand?) { should be_true }
    end

    context "when ad is not demand" do
      its(:demand?) { should_not be_true }
    end
  end

  describe "#closed?" do
    context "when it's created more than VALID_DAYS ago" do
      before { subject.created_at = Time.now - (Ad::VALID_FOR + 1).days }
      its(:closed?) { should be_true }
    end

    context "when it's created less than VALID_DAYS ago" do
      before { subject.created_at = Time.now - (Ad::VALID_FOR - 2).days }
      its(:closed?) { should be_false }
    end
  end

  describe "#set_status" do
    context "when supply" do
      before { subject.ad_type = Ad::TYPES[:supply] }
      it "sets status to pending" do
        subject.set_status
        subject.status.should == Ad::STATUS[:pending]
      end
    end

    context "when demand" do
      before { subject.ad_type = Ad::TYPES[:demand] }
      it "sets status to active" do
        subject.set_status
        subject.status.should == Ad::STATUS[:active]
      end
    end

    it "sets status to closed" do
      subject.set_status
      subject.status.should == Ad::STATUS[:closed]
    end
  end
end
