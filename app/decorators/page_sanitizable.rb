module PageSanitizable
  def allowed_html_tags
    %w(p br b i a)
  end
end