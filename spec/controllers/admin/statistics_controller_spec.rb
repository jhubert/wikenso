require 'spec_helper'

describe Admin::StatisticsController do
  describe "GET 'index'" do
    before(:each) do
      controller.stub(:authorize!).and_return(true)
    end

    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "assigns all the wikis in the system" do
      wikis = create_list(:wiki, 5)
      get :index
      assigns(:wikis).should == wikis
    end

    it "assigns a wikis decorator" do
      wikis = create_list(:wiki, 5)
      get :index
      assigns(:wikis).should be_a WikisDecorator
    end

    it "renders the `index` template" do
      get :index
      response.should render_template :index
    end

    context "authorization" do
      before(:each) do
        controller.stub(:authorize!).and_call_original
      end

      it "doesn't allow non-super-admins to access the action" do
        user = create(:active_user, :normal)
        sign_in(user)
        expect { get :index }.to raise_error(CanCan::AccessDenied)
      end

      it "allows super admins to access the action" do
        user = create(:active_user, :super_admin)
        sign_in(user)
        get :index
        response.should be_ok
      end
    end
  end
end
