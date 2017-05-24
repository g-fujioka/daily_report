require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  def setup
    @comment = Comment.new(report_id: 1, content: 'comment')
  end

  test 'content presence' do
    @comment.content = ''
    assert_not @comment.valid?
  end
end
