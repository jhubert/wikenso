class PageDecorator < Draper::Decorator
  delegate_all

  def allowed_html_tags
    %w(p br b i)
  end
end
