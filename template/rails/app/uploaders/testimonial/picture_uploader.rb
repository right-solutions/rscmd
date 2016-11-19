class Testimonial::PictureUploader < ImageUploader
	def store_dir
    "uploads/testimonials/pictures/#{model.id}"
  end

	version :large do
    process :resize_to_fill => [250, 250]
  end

  version :medium do
    process :resize_to_fill => [120, 120]
  end

  version :small do
    process :resize_to_fill => [60, 60]
  end

  version :tiny do
    process :resize_to_fill => [25, 25]
  end
end
