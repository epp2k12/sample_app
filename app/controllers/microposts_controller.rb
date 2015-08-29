class MicropostsController < ApplicationController
	before_action :logged_in_only, only: [:create, :destroy]
	before_action :correct_user,   only: [:destroy]

	def create
		@microposts = current_user.feed.paginate(page: params[:page], :per_page => 200 )
		@micropost = current_user.microposts.build(micropost_params)
		if @micropost.save
			# flash[:success] = "Micropost created!"
			# redirect_to root_url
			respond_to do |format|
  				format.js
  				format.html
			end
		else
			# should the posting fail the home page still would expect @feed_items instance
			# so we assign an empty array for @feed_items for failed submissions
			# @feed_items = []
			@microposts = current_user.feed.paginate(page: params[:page], :per_page => 200 )
			# render 'static_pages/home'

			respond_to do |format|
        	 format.js { j (render "error_micropost") }
             format.html
		    end
		end
	end

	def destroy
		@micropost.destroy
		# flash[:success] = "Micropost deleted"
		# redirect_to request.referrer || root_url
		respond_to do |format|
			format.html
			format.js { render :layout => false }
		end
	end

private

	def micropost_params
		params.require(:micropost).permit(:content, :picture)
	end

	def correct_user
		@micropost = current_user.microposts.find_by(id: params[:id])
		# request.referrer means the previous URL (Home page or Show Page)
		redirect_to root_url if @micropost.nil?
	end
end
