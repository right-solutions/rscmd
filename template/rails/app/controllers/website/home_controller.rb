class Website::HomeController < Website::BaseController

	layout 'website/home'

	def index
		@testimonials = Testimonial.published.order("created_at desc").all
	end

	def about_us
		set_nav("website/about_us")
		set_title("About Us | <Application Name>")
	end

	def subscribe
		@subscription = Subscription.new
		@subscription.email = params[:email]
		@subscription.save
    set_flash_message(:subscription, :success) if @subscription.errors.blank?
	end

	private

	def set_navs
    set_nav("website/home")
  end
	
end
