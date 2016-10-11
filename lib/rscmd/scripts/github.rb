module Scripts
	class Github

		def self.create_repository(name, **options)

			# Symolizing Keys in the Options Hash
			options = options.inject({}){|h,(k,v)| h.merge({ k.to_sym => v}) }

			# Authenticating Github User
			settings = {
				login: "<login>",
				password: "<password>"
			}.merge(options)

			repo_details = {
				description: nil,
				homepage: nil,
				private: true,
				has_issues: false,
				has_wiki: false,
				has_downloads: false,
				auto_init: false,
				organization: "right-solutions"
			}.merge(options)

			gh_client = Octokit::Client.new login: settings[:login], :password => settings[:password]

			begin
				user = gh_client.user
				user.login
			rescue
				Kernel.abort("Abort! Github Authentication Failed. Please check your username and password. Also make sure that you have admin access to the organization so that the repository can be created.")
			end

			puts repo_details
			puts "Creating the repository #{name} in organization: #{repo_details[:organization]} as user: #{settings[:login]}"
			gh_client.create_repository name, repo_details

			return gh_client
		end

		def self.setup(name, path, login, password)

			Dir.chdir("#{path}/#{name}") do

		  	# Initialize Git
		  	puts "Initializing the git in the project folder"
		  	`git init`

		  	# Create Github Repository
		  	puts "Creating the repository in github ..."
		  	create_repository name, login: login, password: password

				# Adding Remote Refs
				puts "Adding Remote ref to origin"
				`git remote add origin https://github.com/right-solutions/#{name}`

				# Adding the files to the first commit
				`git add .`
				`git commit -a -m'First Commit'`

				# Pushing to the master branch
				`git push origin master`
				
			end
		end

	end
end