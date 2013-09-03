class PageDecorator < Draper::Decorator
  delegate_all
  include PageSanitizable

  def show_history?
    versions.map(&:whodunnit).compact.present?
  end
end
