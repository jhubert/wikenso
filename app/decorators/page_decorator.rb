class PageDecorator < Draper::Decorator
  delegate_all

  def allowed_html_tags
    %w(p br b i a)
  end
end
