class RelationshipsController < ApplicationController
before_action :logged_in_only

def create
	@user=User.find(params[:followed_id])
	@mywords = URI(request.referer).path
	@current_user = current_user 
	current_user.follow(@user)
	url=user_url(@user)
	respond_to do |format|
		format.html
        format.js 
	end
end

def destroy

	# parameter passed = id in the relationship table
	# this id is determined by finding the current user relationship
	# with the queried user
	# current_user.active_relationships.find_by(followed_id: @user.id)
	# where @user.id is the queried user's id in the show profile template

	# the user below is the user with followed_id in the relationships table
	# at relationships ID given by the parameter
	@user = Relationship.find(params[:id]).followed 
	current_user.unfollow(@user)
	url = user_url(@user)
	respond_to do |format|
		format.html 
		format.js 
	end
end
end
