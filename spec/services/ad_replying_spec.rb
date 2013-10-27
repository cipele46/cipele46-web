require_relative "../../app/services/ad_creation"

describe AdReplying do
  context "when valid arguments were given" do
    before do
      ad = create(:ad)
      email = "pero@cipele46.org"
      content = "wow, your ad is amazing!"

      valid_arguments = {
        ad: ad,
        email: email,
        content: content
      }

      @it = lambda { AdReplying.new.call!(valid_arguments) }
    end

    it "creates new ad reply" do
      expect(@it).to change { Reply.count }.from(0).to(1)
    end
  end

  context "when invalid arguments were given" do
    before do
      @it = lambda { AdReplying.new.call!("u mad bro?") }
    end

    it "goes wild with exceptions" do
      expect(@it).to raise_exception
    end
  end
end
