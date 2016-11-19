module Admin
  class EnquiriesController < Admin::ResourceController

  	def update_status
      @enquiry = Enquiry.find(params[:id])
      @enquiry.update_attribute(:status, params[:status])
      render_show
    end

    private

    def permitted_params
      params[:enquiry].permit(:name, :email, :phone, :subject, :message)
    end

    def get_collections
      # Fetching the messages
      relation = Enquiry.where("")
      
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
      else
        relation = relation.unarchived
      end
      
      @enquiries = relation.order("created_at desc").page(@current_page).per(@per_page)

      ## Initializing the @enquiry object so that we can render the show partial
      @enquiry = @enquiries.first unless @enquiry

      return true
    end

    def set_navs
      set_nav("admin/enquiries")
    end

  end
end
