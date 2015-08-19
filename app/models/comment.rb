class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :micropost
  validates :comment, presence: true, length: { maximum: 140 }
  default_scope -> { order('created_at DESC')}
end
