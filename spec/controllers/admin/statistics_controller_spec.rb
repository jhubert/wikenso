require 'spec_helper'

describe Admin::StatisticsController do
  describe "GET 'index'" do
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
  end
end
