module Admin
  class StatisticsController < ApplicationController
    def index
      @wikis = WikisDecorator.decorate(Wiki.all)
    end
  end
end