require 'spec_helper'
module Api
  module V1
    describe DraftPagesController do
      let(:user) { create(:active_user) }
      before(:each) { sign_in(user) }

      context "PUT 'update'" do

        context "when the save is successful" do
          it "returns http success" do
            page = create(:draft_page, title: "Bar", user: user)
            put :update, id: page.id, draft_page: {title: "Foo"}
            response.should be_success
          end

          it "updates the draft page corresponding to the passed ID" do
            page = create(:draft_page, title: "Bar", user: user)
            put :update, id: page.id, draft_page: {title: "Foo"}
            page.reload.title.should == "Foo"
          end

          it "returns an empty hash so that backbone doesn't update its local model" do
            page = create(:draft_page, title: "Bar", text: "Baz", user: user)
            put :update, id: page.id, draft_page: {title: "Foo"}
            JSON.parse(response.body).should == {}
          end
        end

        context "if the save fails due to a validation error" do
          before(:each) do
            DraftPage.any_instance.stub(:update).and_return(false)
          end

          it "returns a 400 if the save fails due to a validation error" do
            page = create(:draft_page, user: user)
            put :update, id: page.id, draft_page: {title: nil}
            response.status.should == 400
          end

          it "doesn't update the page" do
            page = create(:draft_page, text: "Foo", user: user)
            put :update, id: page.id, draft_page: {title: nil, text: "Bar"}
            page.reload.text.should == "Foo"
          end

          it "returns the errors in JSON" do
            page = create(:draft_page, title: "Bar", text: "Baz", user: user)
            Page.any_instance.stub(:errors).and_return({title: ["can't be blank"]})

            errors = {title: ["can't be blank"]}
            DraftPage.any_instance.stub(:errors).and_return(errors)

            put :update, id: page.id, draft_page: {title: nil}
            response_hash = JSON.parse(response.body).symbolize_keys
            response_hash.slice(:title).should == errors
          end
        end

        it "raises an error if no ID is passed" do
          expect { put :update, draft_page: {title: "Foo"} }.to raise_error
        end

        context "authorization" do
          it "doesn't allow access when no user is logged in" do
            session[:user_id] = nil
            page = create(:draft_page, title: "Bar", user: user)
            put :update, id: page.id, draft_page: {title: "Foo"}
            response.should_not be_success
          end

          it "doesn't allow access when the draft page belongs to another user" do
            page = create(:draft_page, title: "Bar", user: create(:active_user))
            expect { put :update, id: page.id, draft_page: {title: "Foo"} }.to raise_error
            page.reload.title.should_not == "Foo"
          end
        end
      end
    end
  end
end