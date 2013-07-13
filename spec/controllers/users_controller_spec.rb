require 'spec_helper'

describe UsersController do

  before (:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe 'GET show' do
    before { get :show }

    it 'should be successful' do
      response.should be_success
    end
    
    it 'should render template show' do
      response.should render_template('show')
    end
    
    it 'should return the logged on user' do
      expect(assigns(:current_user)).to eq @user
    end
  end
end
