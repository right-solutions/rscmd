module Scripts
	class Rails

		def self.create_gitignore_file
			source_dir = File.expand_path('../../../../', __FILE__)
			
			# Adding the .gitignore
			Scripts::IO.display_heading("Adding the .gitignore")
			`cp -fr #{source_dir}/template/rails/.gitignore .gitignore`
		end

		def self.cleanup_rails_files
			# Removing unnecessary folders and files

			Dir.chdir('src') do

				source_dir = File.expand_path('../../../../', __FILE__)

				# Removing unnecessary folders and files
				Scripts::IO.display_heading("Removing unnecessary folders and files")
				`rm -fr test/ .gitignore `

				# Adding required folder
				Scripts::IO.display_heading("Creating the required folders")
				`mkdir app/spec`

				# Copying basic setup files
				Scripts::IO.display_heading("Copying basic setup files")
				`cp -fr #{source_dir}/template/rails/.gitignore .gitignore`
				`cp -fr #{source_dir}/template/rails/.gitignore .gitignore`
				`cp -fr #{source_dir}/template/rails/.ruby-version .ruby-version`
				`cp -fr #{source_dir}/template/rails/Capfile Capfile`
				`cp -fr #{source_dir}/template/rails/Gemfile Gemfile`

				# Adding the config files
				Scripts::IO.display_heading("Copying the config files to start with")
				`cp -fr #{source_dir}/template/rails/config/database.yml config/database.yml`
				`cp -fr #{source_dir}/template/rails/config/deploy.rb config/deploy.rb`
				`cp -fr #{source_dir}/template/rails/config/deploy.rb config/deploy.rb`
				`cp -fr #{source_dir}/template/rails/config/initializers/carrierwave.rb config/initializers/carrierwave.rb`
				`cp -fr #{source_dir}/template/rails/config/initializers/config_center.rb config/initializers/config_center.rb`
				`cp -fr #{source_dir}/template/rails/config/initializers/poodle_validators.rb config/initializers/poodle_validators.rb`
				`cp -fr #{source_dir}/template/rails/config/initializers/assets.rb config/initializers/assets.rb`
				`cp -fr #{source_dir}/template/rails/config/locales/en.yml config/locales/en.yml`
				`cp -fr #{source_dir}/template/rails/config/routes.rb config/routes.rb`
				
				# Replacing the assets folder with our tempalte
				Scripts::IO.display_heading("Copying the RS basic tempalte files")
				`rm -fr app/assets/`
				`cp -fr #{source_dir}/template/rails/app/assets app/assets`

				`rm -fr app/controllers/`
				`cp -fr #{source_dir}/template/rails/app/controllers app/controllers`

				`rm -fr app/views/`
				`cp -fr #{source_dir}/template/rails/app/views app/views`

				`rm -fr app/models/`
				`cp -fr #{source_dir}/template/rails/app/models app/models`

				`rm -fr app/services/`
				`cp -fr #{source_dir}/template/rails/app/services app/services`

				`rm -fr app/helpers/`
				`cp -fr #{source_dir}/template/rails/app/helpers app/helpers`

				`rm -fr app/uploaders/`
				`cp -fr #{source_dir}/template/rails/app/uploaders app/uploaders`

				`rm -fr db/`
				`cp -fr #{source_dir}/template/rails/db db`

				# Replacing the assets folder with our tempalte
				Scripts::IO.display_heading("Copying the import files")
				`rm -fr lib/tasks`
				`cp -fr #{source_dir}/template/rails/lib/tasks lib/tasks`
				
			end
		end

		def self.create(domain, path, database="mysql")

			puts "Creating a rails project in folder structure for #{domain} in #{path}"

			Dir.chdir(path) do
				# Check if the mentioned directory exist and overide if required
				if Dir.exist?(domain)
					error_message = "Error! Directory #{domain} Exist. Overide? Y / N or Any Key"
					Scripts::IO.display_heading(error_message, :red)
					overide = STDIN.gets.chomp
					Kernel.abort("Abort! Directory #{domain} Exist") unless overide.capitalize == "Y"
					FileUtils.rm_rf(domain)
				end

				# Create the Parent Folder for the project
				Scripts::IO.display_heading("Creating the project foler '#{domain}'")
				`mkdir #{domain}`

				Dir.chdir(domain) do
					# Create the folders
					Scripts::IO.display_heading("Creating the template and releases folder")
					`mkdir template`
					`mkdir releases`

					# Adding .gitignore file
					Scripts::IO.display_heading("Adding the .gitignore file")
					create_gitignore_file

					# Create the rails project
					Scripts::IO.display_heading("Creating the rails application with mysql database")
					`rails new src --skip-bundle --database=mysql`

					# Remove unnecessary files created by rails
					Scripts::IO.display_heading("Cleaning up the project folder")
					cleanup_rails_files

					# Display Instructions
					instructions = [
						{
							heading: "Install all the gems mentioned in the Gemfile.",
							description: [
								"cd <project_path>/src",
								"$ 'bundle install'"
							]
						},
						{
							heading: "Change the database name for all environments in database.yml file.",
							description: [
								"You shall find the database.yml in config folder in src."
							]
						},
						{
							heading: "Create Database and run migrations.",
							description: [
								"$ rake db:create db:migrate"
							]
						},
						{
							heading: "Start the rails server.",
							description: [
								"$ rails s -p 3000"
							]
						}					]
					
					Scripts::IO.display_instructions(instructions)

				end
			end
		end
	end
end