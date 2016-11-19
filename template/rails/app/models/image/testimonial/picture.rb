class Image::Testimonial::Picture < Image::Base
	mount_uploader :image, Testimonial::PictureUploader
end
