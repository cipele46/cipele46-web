require 'active_support/core_ext'

require_relative '../../lib/extensions/ad/expiration'
require_relative '../../lib/extensions/ad/type'
require_relative '../../lib/extensions/ad/status'
require_relative '../../lib/extensions/ad/delegation'
require_relative '../../lib/extensions/ad/searchable'


class Ad
  attr_accessor :status

  include Extensions::Ad::Expiration
  include Extensions::Ad::Type
  include Extensions::Ad::Status
  include Extensions::Ad::Delegation

end

class AdSearchMock
  def self.searchable
    yield
  end
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
      context "when it has expired" do
        before { subject.stub(:expired?) { true } }
        its(:closed?) { should be_true }
      end

      context "when it has not expired" do
        before { subject.stub(:expired?)  { false } }
        its(:closed?) { should be_false }

        context "and the status is explicitly set to closed" do
          before { subject.stub(:status) { Ad.status[:closed] } }
          its(:closed?) { should be_true }
        end
      end

    end

    describe "#pending?" do
      context "when status is not set to pending" do
        its(:pending?) { should be_false }
      end

      context "when status is set to pending" do
        before { subject.stub(:status) { Ad.status[:pending] }}
        its(:pending?) { should be_true }
      end
    end

    describe "#active?" do
      context "when it has expired" do
        before { subject.stub(:expired?) { true } }
        its(:active?) { should be_false }
      end

      context "when it has not expired" do
        before { subject.stub(:expired?) { false } }
        its(:active?) { should be_false }

        context "and the status is explicitly set to active" do
          before { subject.stub(:status) { Ad.status[:active] } }
          its(:active?) { should be_true }
        end
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

  describe "#close!" do
    it "calls close" do
      subject.should_receive(:close)
    end

    it "calls save" do
      subject.should_receive(:save)
    end

    after do
      subject.stub(:save)
      subject.close!
    end
  end

  describe "close" do
    before do
      subject.close
    end

    it "sets status to :closed" do
      subject.status.should eq(Ad.status[:closed])
    end
  end

  describe "#activate!" do
    it "calls activate" do
      subject.should_receive(:activate)
    end

    it "calls save" do
      subject.should_receive(:save)
    end

    after do
      subject.stub(:save)
      subject.activate!
    end
  end

  describe "activate" do
    before do
      subject.activate
    end

    it "sets status to :active" do
      subject.status.should eq(Ad.status[:active])
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

  describe "#type_name" do
    context "for supplying ad" do
      before { subject.stub(:ad_type) { Ad.type[:supply] } }
      its(:type_name) { should eq(:supply) }
    end

    context "for demanding ad" do
      before { subject.stub(:ad_type) { Ad.type[:demand] } }
      its(:type_name) { should eq(:demand) }
    end
  end

  describe "delegations" do
    it "delegates region to city" do
      city = double
      city.should_receive(:region)
      subject.stub(:city) { city }
      subject.region
    end
  end

  context 'Search setup', sunspot_matchers: true do
    before do
      AdSearchMock.stub(:text)
      AdSearchMock.stub(:integer)
      AdSearchMock.stub(:time)
    end

    #These can't be separated in a feasible way
    it 'should add fields for fulltext search, filtering and sorting' do
      AdSearchMock.should_receive(:text).with(:title, boost: 4.0)
      AdSearchMock.should_receive(:text).with(:description, boost: 2.0)
      AdSearchMock.should_receive(:text).with(:phone)
      AdSearchMock.should_receive(:text).with(:category)
      AdSearchMock.should_receive(:text).with(:city)
      AdSearchMock.should_receive(:text).with(:region)
      AdSearchMock.should_receive(:integer).with(:region_id)
      AdSearchMock.should_receive(:integer).with(:category_id)
      AdSearchMock.should_receive(:integer).with(:ad_type)
      AdSearchMock.should_receive(:integer).with(:status)
      AdSearchMock.should_receive(:time).with(:created_at)
      AdSearchMock.send(:include, Extensions::Ad::Searchable)
    end
  end
end
