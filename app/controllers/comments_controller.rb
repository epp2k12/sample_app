class CommentsController < ApplicationController
  def new
  	@comment = Comment.new
  	store_forwarding_url
  end

  def error_comment

  end

  def create

  	f_url = params[:comment][:f_url]
    @micropost = Micropost.find_by(id: params[:comment][:micropost_id])
    @micropost.touch
    # @comments = @micropost.comments.all
  	@comment = Comment.new(comment_params)
  
  	if @comment.save 
  		flash[:danger] =  f_url 
  		# redirect_to f_url
      respond_to do |format|
        format.js
        format.html
      end
  	else
      respond_to do |format|
        format.js { j (render "error_comment") }
        format.html
      end
  		#flash[:danger] =  "something wrong"
  		#redirect_to f_url 
  	end 
  	


  end

  def delete

  end

  def destroy

     
  		@comment=Comment.find_by(id: params[:id])
      @micropost = Micropost.find_by(id: @comment.micropost_id)
      @comment.destroy

      respond_to do |format|
        format.js
        format.html
      end

		  # flash[:success] = "Comment deleted"
		  # redirect_to request.referrer || root_url

  end


private

	def comment_params
		params.require(:comment).permit(:user_id, :micropost_id , :comment)
	end




end
