module Admin
  class ImagesController < Admin::BaseController

    skip_before_action :set_navs, :parse_pagination_params
    before_action :get_image_class
    before_action :get_resource

    def new
      @image = @image_class.new
    end

    def edit
      @image = @image_class.find(params[:id])
    end

    def create
      @image = @image_class.new
      @image.imageable = @resource
      @image.image = params[:image]
      @image.save
      set_flash_message("Image has been created successfully", :success)
      render layout: "image_upload"
    end

    def update
      @image = @image_class.find(params[:id])
      @image.image = params[:image]
      @image.save
      set_flash_message("Image has been updated successfully", :success)
      render layout: "image_upload"
    end

    def crop
      @image = @image_class.find(params[:id])
      @image.assign_attributes(image_params)
      @image.image = params[:image]
      @image.save
      set_flash_message("Image has been cropped successfully", :success)
      render layout: "image_upload"
    end

    private

    def image_params
      params.require(:image).permit(:crop_x, :crop_y, :crop_w, :crop_h, :image)
    end

    def get_image_class
      @image_type = params[:image_type]
      @image_class = @image_type.constantize
    end

    def get_resource
      @resource = params[:imageable_type].constantize.find(params[:imageable_id]) if params[:imageable_type] && params[:imageable_id]
    end

    def save_image
      @image = @image_class.new
      @image.imageable = @resource
      @image.image = params[:image][:image]
      @image.save
    end

  end
end
