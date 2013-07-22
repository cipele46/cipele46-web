require_relative "../../app/services/ad_creation"

describe AdCreation do
  before do
    @ad = double
    @ad.stub(:set_status)
    @ad.stub(:save)

    @user = double
    @user.stub_chain(:ads, :new) { @ad }
  end

  subject { AdCreation.new(@user) }

  it "creates ad" do
    @ad.should_receive(:set_status)
    subject.create(nil).should == @ad
  end

  context "when ad is saved with success" do
    it "sends email" do
      @ad.should_receive(:save) { true }
      
      subject.should_receive(:notify_admin)

      subject.create(nil)
    end
  end
end
