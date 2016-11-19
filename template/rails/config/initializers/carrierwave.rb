CarrierWave.configure do |config|

	if Rails.env.production?
		config.storage = :fog
		config.fog_credentials = {
	      :provider               => 'AWS', # required
	      :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'], # required
	      :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],
	      :region                 => 'us-west-2'
	    }

	  config.fog_directory  = ENV['AWS_S3_BUCKET_NAME'] # required
	  config.fog_public     = false    # optional, defaults to true
	  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'} # optional, defaults to {}
	  
	elsif Rails.env.test? || Rails.env.cucumber?
	 	config.storage = :file
	 	config.enable_processing = false
	 	config.root = "#{Rails.root}/tmp"

	elsif Rails.env.development?
	 	config.storage = :file
	 	
	end
end