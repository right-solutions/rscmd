module Scripts
	class AWS
		def self.create_bucket(name)
			`s3cmd mb s3://#{name}`
		end

		def self.backup(name)
			`s3cmd sync s3://tecadmin/mydir/ /root/mydir/`
		end

		def self.sync(name)
			`s3cmd sync /root/mydir/ --delete-removed s3://tecadmin/mydir/`
		end

		def self.compress(site_dir="_site")
			pwd = Pathname.new(".")
			absolute_path = pwd.realpath + site_dir
			if Dir.exist?(absolute_path)
				`find #{absolute_path} \( -iname '*.html' -o -iname '*.css' -o -iname '*.js' \) -exec gzip -9 -n {} \; -exec mv {}.gz {} \;`
			else
				puts absolute_path
				puts "Error! Directory #{absolute_path} doesn't exist"
			end
		end

		def self.build(domain, path)

			puts "Creating the build in production environment."

	    Dir.chdir("#{path}/#{name}") do
	    	`rm -fr _site`
	    	`JEKYLL_ENV=production jekyll build`
	    end
			
		end

	end
end