module Scripts

	class Optimizer

		def self.optimize_image(path)
			image_path = Dir.exist?(path) ? Pathname.new(path) : Shellwords.shellescape(Pathname.new(".").realpath.to_s) + "/" + Shellwords.shellescape(path.to_s)
			image = Pathname.new(image_path)
			if image.extname == ".jpg" or image.extname == ".jpeg"
				puts "Optimizing #{image_path}".colorize(:blue)
				`jpegoptim #{image_path} -m90`
			elsif image.extname == ".png"
				puts "Optimizing #{image_path}".colorize(:cyan)
				`optipng -o7 #{image_path}`
			end
		end

		def self.optimize_image_directory(path)
			Dir.foreach(path.realpath.to_s) do |item|
				next if item == '.' or item == '..'
				next if item.start_with?(".")
				child_path = path + Pathname.new(item)
			  child_path.directory? ? optimize_image_directory(child_path) : optimize_image(child_path)
			end
		end

		def self.optimize_images(path)
			image_path = Dir.exist?(path) ? Pathname.new(path) : Pathname.new(".").realpath + path
			optimize_image_directory(image_path)
		end

	end
	
end