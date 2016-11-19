class Website::ContactUsController < Website::BaseController

	layout 'website/home'

	def index
		@enquiry = Enquiry.find_by_id(params[:id]) if params[:id]
		set_title("Contact Us | <Application Name>")
	end

	def create
		@enquiry = Enquiry.new
		@enquiry.assign_attributes(permitted_params)
		@enquiry.save
    set_flash_message(:enquiry, :success) if @enquiry.errors.blank?
    redirect_to contact_us_path(id: @enquiry.id)
	end

	private

	def permitted_params
    params["enquiry"].permit(:name, :email, :phone, :subject, :message)
  end

	def set_navs
    set_nav("website/contact_us")
  end
	
end
