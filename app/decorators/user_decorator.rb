class UserDecorator < Draper::Decorator
  delegate_all

  def remember_me
    '1'
  end
end
