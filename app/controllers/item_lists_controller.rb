class ItemListsController < ApplicationController
  load_and_authorize_resource
  before_action :company, execpt: :show
  before_action :select_data, only: [:new, :create, :edit, :update]

  def index
    @item_lists = @company.item_lists.find_data
  end

  def new
  end

  def create
    @item_list = @company.item_lists.new item_list_params
    if @item_list.save
      flash[:notice] = t "flashs.messages.created"
      redirect_to item_lists_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @item_list.update_attributes item_list_params
      flash[:notice] = t "flashs.messages.updated"
      redirect_to item_lists_path
    else
      render :edit
    end
  end

  def destroy
    @item_list.destroy
    flash[:notice] = t "flashs.messages.deleted"
    redirect_to item_lists_path
  end

  private
  def company
    @company = current_user.company
  end

  def select_data
    @types = ItemListType.all.collect{|type| [type.name, type.id]}
    @chart_accounts = @company.chart_of_accounts.find_data.collect{|account| [account.name,
      account.id, {"data-type" => account.chart_account_type_name}]}
    @customer_venders = @company.customer_venders.collect{|cv| [cv.name, cv.id]}
    @measures = @company.measures.includes :unit_of_measures
  end

  def item_list_params
    params.require(:item_list).permit :item_list_type_id, :name, :description,
      :chart_of_account_id, :manufacturer_part_number, :customer_vender_id,
      :unit_of_measure_id, :cost, :purchase_description, :price, :sale_description,
      :cogs_account_id, :income_account_id
  end
end
