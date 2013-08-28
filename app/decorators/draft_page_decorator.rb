class DraftPageDecorator < Draper::Decorator
  delegate_all
  include PageSanitizable
end
