class MeasuresController < ApplicationController
  load_and_authorize_resource
  before_action :company, execpt: :show

  def index
    @measures = @company.measures
  end

  def new
  end

  def create
    @measure = @company.measures.new measure_params
    if @measure.save
      flash[:notice] = t "flashs.messages.created"
      redirect_to measures_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @measure.update_attributes measure_params
      flash[:notice] = t "flashs.messages.updated"
      redirect_to measures_path
    else
      render :edit
    end
  end

  def destroy
    @measure.destroy
    flash[:notice] = t "flashs.messages.deleted"
    redirect_to measures_path
  end

  private
  def company
    @company = current_user.company
  end

  def measure_params
    params.require(:measure).permit :name, :abbreviation,
      unit_of_measures_attributes: [:id, :name, :abbreviation, :_destroy]
  end
end
