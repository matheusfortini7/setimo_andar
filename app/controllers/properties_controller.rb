class PropertiesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_property, only: %i[show edit update destroy]

  def index
    properties = policy_scope(Property).order(created_at: :desc)

    @properties = properties.select do |property|
      property.sales.ids == []
    end
  end

  def show
    @property = Property.find(params[:id])
    @sale = Sale.new
    authorize @property
  end

  def new
    @property = Property.new
    authorize @property
  end

  def create
    @property = Property.new(property_params)
    @property.user = current_user
    authorize @property
    if @property.save
      redirect_to property_path(@property)
    else
      render :new
    end
  end

  def edit
    @property = Property.find(params[:id])
    authorize @property
  end

  def update
    @property = Property.find(params[:id])
    authorize @property
    @property.update(property_params)

    redirect_to properties_path
  end

  def destroy
    @property = Property.find(params[:id])
    authorize @property
    @property.destroy
    redirect_to properties_path
  end

  private

  def property_params
    params.require(:property).permit(:title, :description, :street_name, :city, :state, :country, :price)
  end

  def set_property
    @property = Property.find(params[:id])
  end
end
