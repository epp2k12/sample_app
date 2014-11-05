module UsersHelper

	#returns the Gravatar for the given user.
	def gravatar_for(user)
		gravatar_id = Digest::MD5::hexdigest(user.email)
		gravatar_url = "http://s.gravatar.com/avatar/#{ gravatar_id }?s=80"
		image_tag(gravatar_url, alt: user.name, class: "gravatar" )
	end


end
