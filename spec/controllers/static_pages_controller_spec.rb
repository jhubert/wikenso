require 'spec_helper'

describe StaticPagesController do
  context "GET 'landing_page'" do
    it "returns http success" do
      get 'landing_page'
      response.should be_success
    end

    it "renders the 'landing_page' template" do
      get 'landing_page'
      response.should render_template :landing_page
    end
  end
end
