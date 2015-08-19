class StaticPagesController < ApplicationController
  def home
  	if logged_in?
  		@micropost = current_user.microposts.build
  		# @feed_items = current_user.feed.paginate(page: params[:page], :per_page => 300 )
      @microposts = current_user.feed.paginate(page: params[:page], :per_page => 30 )
      # @comment = current_user.comments.build 
      @comment = Comment.new
  	end

  end

  def help
  end

  def about
  end

  def contact
  end
  
end
