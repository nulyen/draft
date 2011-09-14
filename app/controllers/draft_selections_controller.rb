class DraftSelectionsController < ApplicationController
  before_filter :authenticate_user!
  include DraftSelectionHelper
  
  def new

  end
  
  def create
    @create_errors = insert_draft params[:draftfile]
  end
  


end
