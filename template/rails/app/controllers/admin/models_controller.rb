module Admin
  class ModelsController < Admin::ResourceController

  	def update_status
      @model = Model.find(params[:id])
      @model.update_attribute(:status, params[:status])
      render_show
    end

    def mark_as_featured
      @model = Model.find(params[:id])
      @model.update_attribute(:featured, true)
      render_show
    end

    def remove_from_featured
      @model = Model.find(params[:id])
      @model.update_attribute(:featured, false)
      render_show
    end

    private

    def permitted_params
      params[:model].permit(:name, :description1, :description2, :description3, :description4, :nationality, :featured, :status, :height, :weight, :bust, :waist, :hips, :shoe, :eyes, :address, :phone, :email )
    end

    def set_navs
      set_nav("admin/models")
    end

    def get_collections
      # Fetching the models
      relation = Model.where("")
      
      @filters = ActiveSupport::HashWithIndifferentAccess.new
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

      if params[:featured]
        @featured = ["true", "t","1","yes","y"].include?(params[:featured].to_s.downcase.strip)
        @filters[:featured] = @featured
        relation = relation.where("featured = true")
      end

      @models = relation.order("created_at desc").page(@current_page).per(@per_page)

      ## Initializing the @model object so that we can render the show partial
      @model = @models.first unless @model

      return true
    end

  end
end
