class Image::User::ProfilePicture < Image::Base
	mount_uploader :image, User::ProfilePictureUploader
end
