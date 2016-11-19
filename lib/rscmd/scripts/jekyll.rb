module Scripts
	class Jekyll

		def self.create_gitignore_file
			source_dir = File.expand_path('../../../../', __FILE__)
			# Adding the .gitignore
			`cp -fr #{source_dir}/template/jekyll/.gitignore .gitignore`
		end

		def self.cleanup_jekyll_files
			# Removing unnecessary folders and files

			Dir.chdir('src') do

				source_dir = File.expand_path('../../../../', __FILE__)

				puts "Removing unnecessary folders and files"
				`rm -fr feed.xml about.md .gitignore _sass _posts css index.html _includes _layouts`

				puts "Copying the template files to start with"
				`cp -fr #{source_dir}/template/jekyll/index.html index.html`
				`cp -fr #{source_dir}/template/jekyll/_includes _includes`
				`cp -fr #{source_dir}/template/jekyll/_layouts _layouts`
				`cp -fr #{source_dir}/template/jekyll/_assets _assets`
				
				# Adding the new _config.yml
				`cp -fr #{source_dir}/template/jekyll/_config.yml _config.yml`

				# Adding the Gemfile
				`cp -fr #{source_dir}/template/jekyll/Gemfile Gemfile`
				
			end
		end

		def self.create(domain, path)

			puts "Creating a jekyll project in folder structure for #{domain} in #{path}"

			Dir.chdir(path) do
				# Check if the mentioned directory exist and overide if required
				if Dir.exist?(domain)
					puts "Error! Directory #{domain} Exist. Overide? Y / N or Any Key"
					overide = STDIN.gets.chomp
					Kernel.abort("Abort! Directory #{domain} Exist") unless overide.capitalize == "Y"
					FileUtils.rm_rf(domain)
				end

				# Create the Parent Folder for the project
				`mkdir #{domain}`
				Dir.chdir(domain) do
					# Create the folders
					`mkdir template`
					`mkdir releases`

					# Create .gitignore file
					create_gitignore_file

					# Create the jekyll project
					`jekyll new src`

					# Remove unnecessary files created by jekyll
					cleanup_jekyll_files
				end
			end
		end

	  def self.setup_template(name, path, login, password)
	  	
	    Dir.chdir("#{path}/#{name}") do

	    	# Copying the template
	    	puts "Select the template you want to copy"
	    	template_path = `zenity --file-selection --title="Select the Template"`
	    	template_path.gsub!("\n","")
	    	puts template_path

	    	template = Pathname.new(template_path)
				filename = template.basename.to_s
	    	
	    	puts "Copying the template from #{template_path}"
	    	`cp #{Shellwords.shellescape(template_path)} template`

	    	puts "Extracting the files from the zip"
	    	`unzip template/#{filename} -d template/`

	    	puts "Adding the unzipped template files to .gitignore"
	    	open('.gitignore', 'a') do |g|
					g.puts ""
					g.puts "# Template files #"
					g.puts "######################"
					g.puts ""
				end

	    	Dir.entries("template").select do |f|
	    		next if [filename, ".", ".."].include?(f)
	    		open('.gitignore', 'a') { |g| g.puts "template/#{f}" }	
	    		open('.gitignore', 'a') { |g| g.puts "template/#{f}/*" } if Dir.exist?(f)
	    	end

				# Adding the template file & the modified .gitignore file
				`git add template`
				`git commit template/ .gitignore -m'Added Template Zip File & included its folders to .gitignore'`
				
				# Pushing to the master branch
				`git push origin master`
			end
	  end

	  def self.fill_dummy(name, path)
	  	
	    Dir.chdir("#{path}/#{name}/src") do

	    	puts "Copying the dummy files"
	    	source_dir = File.expand_path('../../../../', __FILE__)

	    	# Removing the default files
	    	`rm -fr index.html _layouts _includes _assets`

	    	# Copying the index file
	    	`cp -fr #{source_dir}/development/dummy/index.html index.html`

	    	# Copying other dummy files
	    	`cp -fr #{source_dir}/development/dummy/_includes _includes`
	    	`cp -fr #{source_dir}/development/dummy/_layouts _layouts`
	    	`cp -fr #{source_dir}/development/dummy/_assets _assets`
	    	
	    	# Adding the new data files
				# create_data_files

			end
	  end

	end
end