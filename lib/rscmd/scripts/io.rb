require 'colorized_string'

module Scripts
	class IO

		DEFAULT_LINE_CHARACTER = "."
		DEFAULT_LINE_COLOR = :light_white
		DEFAULT_LINE_LENGTH = 100

		# [:black, :light_black, :red, :light_red, :green, 
		# :light_green, :yellow, :light_yellow, :blue, 
		# :light_blue, :magenta, :light_magenta, :cyan, 
		# :light_cyan, :white, :light_white, :default]

		DEFAULT_HEADING_COLOR = :green
		DEFAULT_DESCRIPTION_COLOR = :light_green

		DEFAULT_INSTRUCTION_HEADING_COLOR = :red
		DEFAULT_INSTRUCTION_DESCRIPTION_COLOR = :light_black

		def self.display_line(character=DEFAULT_LINE_CHARACTER, color=DEFAULT_LINE_COLOR, length=DEFAULT_LINE_LENGTH)
			puts ColorizedString[character*length].colorize(color)
		end

		def self.blank_line
			puts ""
		end

		def self.display_instructions(instructions)

			display_line
			blank_line
			blank_line

			instructions.each_with_index do |instruction, count|
				puts ColorizedString[" #{count}. #{instruction[:heading]}"].colorize(DEFAULT_INSTRUCTION_HEADING_COLOR)
				instruction[:description].each do |description|
					puts ColorizedString["   #{description}"].colorize(DEFAULT_INSTRUCTION_DESCRIPTION_COLOR)
				end
				blank_line
			end

			blank_line
			blank_line
			display_line
			
		end

		def self.display_heading(text, color=DEFAULT_HEADING_COLOR)
			blank_line
			puts ColorizedString[text].colorize(color)
		end

		def self.display_description(text, color=DEFAULT_DESCRIPTION_COLOR)
			puts ColorizedString["  #{text}"].colorize(color)
		end

	end
end