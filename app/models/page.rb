class Page < ActiveRecord::Base
  belongs_to :user
  belongs_to :wiki

  validates_presence_of :title
end
