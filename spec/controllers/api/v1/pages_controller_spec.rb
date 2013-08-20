require 'spec_helper'
module Api
  module V1
    describe PagesController do
      context "PUT 'update'" do

        context "when the save is successful" do
          it "returns http success" do
            page = create(:page, title: "Bar")
            put :update, id: page.id, page: {title: "Foo"}
            response.should be_success
          end

          it "updates the page corresponding to the passed ID" do
            page = create(:page, title: "Bar")
            put :update, id: page.id, page: {title: "Foo"}
            page.reload.title.should == "Foo"
          end

          it "returns an empty hash so that backbone doesn't update its local model" do
            page = create(:page, title: "Bar", text: "Baz")
            put :update, id: page.id, page: {title: "Foo"}
            JSON.parse(response.body).should == {}
          end
        end

        context "if the save fails due to a validation error" do
          it "returns a 400 if the save fails due to a validation error" do
            page = create(:page)
            put :update, id: page.id, page: {title: nil}
            response.status.should == 400
          end

          it "doesn't update the page" do
            page = create(:page, text: "Foo")
            put :update, id: page.id, page: {title: nil, text: "Bar"}
            page.reload.text.should == "Foo"
          end

          it "returns the errors in JSON" do
            page = create(:page, title: "Bar", text: "Baz")
            put :update, id: page.id, page: {title: nil}
            response_hash = JSON.parse(response.body).symbolize_keys
            response_hash.slice(:title).should == {title: ["can't be blank"]}
          end
        end

        it "raises an error if no ID is passed" do
          expect { put :update, page: {title: "Foo"} }.to raise_error
        end
      end
    end
  end
end