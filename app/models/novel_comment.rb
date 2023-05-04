class NovelComment < ApplicationRecord
  belongs_to :user
  belongs_to :novel

  validates :comment,length:{maximum:100}
end
