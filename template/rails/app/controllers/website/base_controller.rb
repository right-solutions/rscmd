class Website::BaseController < ApplicationController
  
  layout 'website/home'
  
  private

  def stylesheet_filename
    @stylesheet_filename = "application"
  end

  def javascript_filename
    @javascript_filename = "application"
  end 
end
