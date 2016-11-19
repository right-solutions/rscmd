require 'colorize'
require 'colorized_string'
puts ""
puts "#{ColorizedString.colors}"
puts ""

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
	}
]
Scripts::IO.display_instructions(instructions)