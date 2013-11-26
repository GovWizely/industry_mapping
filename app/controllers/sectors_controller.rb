class SectorsController < ApplicationController
  def lookup
    @sector = Emenu.find_by_name(params[:emenu]).sector
    render
  rescue NoMethodError
    head :not_found
  end
end