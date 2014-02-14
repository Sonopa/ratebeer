class PlacesController < ApplicationController
  before_action :set_place, only:[:show]
  def index
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    session[:searched_city] = params[:city]
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index
    end
  end

  def show
  end

  private

  def set_place
    @place = BeermappingApi.places_in(session[:searched_city]).select {|place| place.id == params[:id].to_s}.first
  end
end