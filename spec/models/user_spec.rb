require 'devise'
require_relative "../../lib/extensions/user/naming"
require_relative "../../lib/extensions/user/social"

class User
  include Extensions::User::Naming
  extend Extensions::User::Social

  attr_accessor :first_name, :last_name, :email, :uid, :provider, :password, :password_confirmation,
    :confirmed, :saved

  def skip_confirmation!
    self.confirmed = true
  end

  def save
    raise :error unless :first_name && :last_name && :email && :password && :password_confirmation && :uid
    self.saved = true
  end
end

describe User do
  it "has name" do
    user = User.new
    user.stub(:first_name) { "Bugs" }
    user.stub(:last_name) { "Bunny" }

    user.name.should == "Bugs Bunny"
  end


  describe '#find_for_facebook_oauth' do
    let(:facebook_auth_response) do
      {
        :provider => 'facebook',
        :uid => '1234567',
        :info => {
          :nickname => 'perozdero',
          :email => 'pero@fiveminutes.eu',
          :name => 'Pero Zdero',
          :first_name => 'Pero',
          :last_name => 'Zdero',
          :image => 'http://graph.facebook.com/1234567/picture?type=square',
          :urls => { :Facebook => 'http://www.facebook.com/perozdero' },
          :location => 'Zagreb, Croatia',
          :verified => true
        } 
      }
    end

    let(:user) { User.new }

    it 'should try to find the user by uid' do
      User.stub(:find_by_uid_and_provider)
      expect(User).to receive(:find_by_uid_and_provider).with('1234567', :facebook)
      User.find_for_facebook_oauth(facebook_auth_response, nil)
    end

    context 'when user exists' do
      it 'should return the user' do
        User.stub(:find_by_uid_and_provider).and_return(user)
        User.find_for_facebook_oauth(facebook_auth_response, nil).should eq(user)
      end
    end

    context 'for the first time user' do
      before do
        Devise.stub(:friendly_token).and_return('fakepass_extrabit')
        User.stub(:find_by_uid_and_provider).and_return(nil)
      end

      let(:user) do
        User.find_for_facebook_oauth(facebook_auth_response, nil)
      end
      
      it 'should create new user' do
        user.should be
      end

      it 'should set the user''s provider to facebook' do
        user.provider.should eq 'facebook'
      end

      it 'should set the user''s first name' do
        user.first_name.should eq 'Pero'
      end

      it 'should set the user''s last name' do
        user.last_name.should eq 'Zdero'
      end

      it 'should set the user''s email' do
        user.email.should eq 'pero@fiveminutes.eu'
      end

      it 'should set the user''s uid' do
        user.uid.should eq '1234567'
      end

      it 'should skip confirmation' do
        user.confirmed.should be_true
      end

      it 'should set the user''s password to a random string' do
        user.password.should eq('fakepass')
      end

      it 'should set the user''s password confirmation to a random string' do
        user.password_confirmation.should eq('fakepass')
      end

      it 'should save the user' do
        user.saved.should be_true
      end
    end
  end
end
