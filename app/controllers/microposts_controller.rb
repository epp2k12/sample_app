class MicropostsController < ApplicationController
	before_action :logged_in_only, only: [:create, :destroy]
	before_action :correct_user,   only: [:destroy]

	def create
		@micropost = current_user.microposts.build(micropost_params)
		if @micropost.save
			flash[:success] = "Micropost created!"
			redirect_to root_url
		else
			# should the posting fail the home page still would expect @feed_items instance
			# so we assign an empty array for @feed_items for failed submissions
			# @feed_items = []
			@feed_items = current_user.feed.paginate(page: params[:page], :per_page => 200 )
			render 'static_pages/home'
		end
	end

	def destroy
		@micropost.destroy
		flash[:success] = "Micropost deleted"
		redirect_to request.referrer || root_url
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
