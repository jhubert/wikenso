class WikisDecorator < Draper::CollectionDecorator
  def users_count
    Wiki.includes(:users).map(&:users).flatten.compact.count
  end
end
