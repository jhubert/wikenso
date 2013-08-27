class ActiveUserDecorator < Draper::Decorator
  delegate_all

  def status_for_table
    "Active"
  end
end
