class ActiveUserDecorator < Draper::Decorator
  delegate_all

  def status_in_words
    "Active"
  end
end
