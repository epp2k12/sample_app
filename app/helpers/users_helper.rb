module UsersHelper

	#returns the Gravatar for the given user.
	def gravatar_for(user, size=80)
		# logger.debug "uuuuuuuuuuuuuserrrrrr: #{user.email}"
		gravatar_id = Digest::MD5::hexdigest(user.email)
		gravatar_url = "http://s.gravatar.com/avatar/#{ gravatar_id }?s=#{size}"
		image_tag(gravatar_url, alt: user.name, class: "gravatar" )
	end


end
