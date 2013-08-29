class PageVersionDecorator < Draper::Decorator
  delegate_all

  def user_name
    User.find(model.whodunnit).name
  end

  def update_time_string
    time = model.created_at
    if time < 7.days.ago
      "#{time.strftime("%b #{time.day.ordinalize} %Y")}"
    else
      "#{h.time_ago_in_words(time)} ago"
    end
  end
end
