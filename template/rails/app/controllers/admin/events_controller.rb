module Admin
  class EventsController < Admin::ResourceController

  	def update_status
      @event = Event.find(params[:id])
      @event.update_attribute(:status, params[:status])
      render_show
    end

    private

    def permitted_params
      params[:event].permit(:title, :permalink, :venue, :description, :starts_at, :ends_at, :status, :facebook_url, :twitter_url, :google_plus_url, :linkedin_url, :instagram_url, :pinterest_url)
    end

    def get_collections
      # Fetching the messages
      relation = Event.where("")
      
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
        relation = relation.where("status != '#{Event::DELETED}'")
      end
      
      @events = relation.order("created_at desc").page(@current_page).per(@per_page)

      ## Initializing the @event object so that we can render the show partial
      @event = @events.first unless @event

      return true
    end

    def set_navs
      set_nav("admin/events")
    end

  end
end
