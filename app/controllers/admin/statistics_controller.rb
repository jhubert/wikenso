module Admin
  class StatisticsController < ApplicationController
    def index
      authorize! :view, :statistics
      @wikis = WikisDecorator.decorate(Wiki.all)
    end
  end
end