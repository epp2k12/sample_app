module SessionsHelper

	# logs in the given user
	def log_in(user)
		session[:user_id] = user.id
	end

	# remembers a ser in a presistent session
	def remember(user)
		user.remember # updates the db create value for remember_digest, this method is in model user
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token # remember_token is a user model attribute
																 # whose value is a raw random value from User.new_token method		
	end

	#sets a current user wether it is a session or a persistent session using cookies
	def current_user
		if session[:user_id]
			@current_user ||= User.find_by(id: session[:user_id])
		elsif cookies.signed[:user_id]
			user = User.find_by(id: cookies.signed[:user_id])
			if user && user.authenticated?(cookies[:remember_token])
				log_in user # if we are presented with a cookies and that the user id and token is authentic
							# then we log the that user
				@current_user = user
			end
		end
	end

	def logged_in?
		!current_user.nil?
	end	

	def log_out
		forget(current_user)
		session.delete(:user_id)
		@current_user=nil
	end

	def current_user?(user)
		user==current_user

	end

	def redirect_back_to(user)

		redirect_to(session[:forwarding_url] || user )
		session.delete(:forwarding_url)
	end

	def store_forwarding_url
		session[:forwarding_url] = request.url if request.get?
	end

	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end


end
