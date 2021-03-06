class PropertiesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_property, only: %i[show edit update destroy]

  def index
    policy_scope(Property).order(created_at: :asc)

    @properties = Property.includes(:sales).where(sales: { property_id: nil })

    if params[:query].present?
      sql_query = "title ILIKE :query OR address ILIKE :query"
      @properties = @properties.where(sql_query, query: "%#{params[:query]}%")
    else
      @properties
    end

    if params[:type].present?
      sql_query = "title ILIKE :query"
      @properties = @properties.where(sql_query, query: "%#{params[:type]}%")
    else
      @properties
    end

  end

  def my
    @properties = Property.where(user_id: current_user.id)
    authorize @properties
  end

  def show
    @property = Property.find(params[:id])

    @markers = {
        lat: @property.latitude,
        lng: @property.longitude,
        info_window: render_to_string(partial: "info_window", locals: { flat: @property }),
        image_url: helpers.asset_url("home-icon.png")
        }

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

    redirect_to @property
  end

  def destroy
    @property = Property.find(params[:id])
    authorize @property
    @property.destroy
    redirect_to properties_path
  end

  private

  def property_params
    params.require(:property).permit(:title, :description, :address, :price, photos: [])
  end

  def set_property
    @property = Property.find(params[:id])
  end
end
