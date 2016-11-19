module Admin
  class TestimonialsController < Admin::ResourceController

  	def update_status
      @testimonial = Testimonial.find(params[:id])
      @testimonial.update_attribute(:status, params[:status])
      render_show
    end

    private

    def permitted_params
      params[:testimonial].permit(:name, :designation, :organisation, :statement)
    end

    def get_collections
      # Fetching the messages
      relation = Testimonial.where("")
      
      @filters = {}
      if params[:query]
        @query = params[:query].strip
        @filters[:query] = @query
        relation = relation.search(@query) if !@query.blank?
      end

      if params[:status]
        @status = params[:status].strip
        @filters[:status] = @status
        relation = relation.status(@status) if !@status.blank?
      end

      if @filters.blank?
        relation = relation.where("status != '#{Testimonial::DELETED}'")
      end
      
      @testimonials = relation.order("created_at desc").page(@current_page).per(@per_page)

      ## Initializing the @testimonial object so that we can render the show partial
      @testimonial = @testimonials.first unless @testimonial

      return true
    end

    def set_navs
      set_nav("admin/testimonials")
    end

  end
end
