require 'spec_helper'

describe Subdomain, :type => :controller do
  controller(ActionController::Base) do
    include Subdomain
    require_inclusion_of_subdomain(:in => -> { ["foo", "bar", "baz"] })

    def index
      render :text => "HELLO!"
    end
  end

  it "raises a RoutingError if the subdomain is not in the given list" do
    request.host = "quux.wikenso.dev"
    expect { get :index }.to raise_error(ActionController::RoutingError)
  end

  it "executes the original controller action if the subdomain is in the given list" do
    request.host = "foo.wikenso.dev"
    get :index
    response.body.should == "HELLO!"
  end

  it "executes the original controller action if the subdomain is blank" do
    request.host = "wikenso.dev"
    get :index
    response.body.should == "HELLO!"
  end
end