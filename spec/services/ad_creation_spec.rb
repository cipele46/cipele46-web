require_relative "../../app/services/ad_creation"

describe AdCreation do
  before do
    @ad = double
    @ad.stub(:set_status)
    @ad.stub(:save)

    @user = double
    @user.stub_chain(:ads, :new) { @ad }
  end

  subject { AdCreation.new }

  describe "#call" do
    it "creates ad" do
      @ad.should_receive(:set_status)
      subject.call(:user => @user, :params => @ad).should == @ad
    end

    context "when ad is saved with success" do
      it "sends email" do
        @ad.should_receive(:save) { true }

        subject.should_receive(:notify_admin)

        subject.call(:user => @user, :params => @ad)
      end
    end
  end
end
