class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include ApplicationHelper
  include AuthenticationHelper
  include DisplayHelper
  include FlashHelper
  include ImageHelper
  include MetaTagsHelper
  include NavigationHelper
  include NotificationHelper
  include ParamsParserHelper
  include RenderHelper
  include TitleHelper
  include UrlHelper
  include ThemeHelper
  include FormHelper

  ## This filter method is used to fetch current user
  before_action :current_user, :set_default_title, :set_navs,
                :stylesheet_filename, :javascript_filename, 
                :parse_pagination_params
  
  private
  
  def set_default_title
    set_title("<Application Name>")
  end

end
