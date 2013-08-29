class PageVersionDecorator < Draper::Decorator
  delegate_all

  def user_name
    User.find(model.whodunnit).name
  end

  def created_at_time_string
    time = model.created_at
    if time < 7.days.ago
      "#{time.strftime("%b #{time.day.ordinalize} %Y")}"
    else
      "#{h.time_ago_in_words(time)} ago"
    end
  end

  # Papertrail's `reify` returns a 'pre-change' version of the Page
  # We're overriding this so we get a 'post-change' version of the Page
  def reify
    if model.next
      model.next.reify
    else
      model.item
    end
  end
end
