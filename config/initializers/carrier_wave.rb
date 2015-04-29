if Rails.env.production?
	CarrierWave.configure do |config|
		config.fog_credentials = {
			#Configuration for Amazon S3
			:provider		=> 'AWS',
			:aws_access_key_id		=> ENV['AKIAJGQHP6Y3AECZPT6Q'],
			:aws_secret_access_key 	=> ENV['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']
		}
		config.fog_directory= ENV['bucketror']
	end
end