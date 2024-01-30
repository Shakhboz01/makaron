class ProductEntriesController < ApplicationController
  include Pundit::Authorization
  before_action :set_product_entry, only: %i[ show edit update destroy ]

  # GET /product_entries or /product_entries.json
  def index
    @q = ProductEntry.ransack(params[:q])
    @product_entries = @q.result.includes(:product).order(created_at: :desc)
    @product_entries_data = @product_entries
    @product_entries = @product_entries.page(params[:page]).per(70)
  end

  # GET /product_entries/1 or /product_entries/1.json
  def show
  end

  # GET /product_entries/new
  def new
    return redirect_to define_product_destination_product_entries_path if params[:local_entry].nil?

    @product_entry = ProductEntry.new(
      return: params[:return],
      delivery_from_counterparty_id: params[:delivery_from_counterparty_id],
    )
    @products = Product.active.where(for_sale: false)
  end

  def define_product_destination; end

  # GET /product_entries/1/edit
  def edit
  end

  # POST /product_entries or /product_entries.json
  def create
    if product_entry_params['excel_data'].nil?
      @product_entry = ProductEntry.new(product_entry_params)

      respond_to do |format|
        if @product_entry.save
          if @product_entry.delivery_from_counterparty_id.present?
            format.html { redirect_to delivery_from_counterparty_url(@product_entry.delivery_from_counterparty), notice: "Product entry was successfully created." }
          end

          if @product_entry.local_entry
            format.html { redirect_to combination_of_local_product_path(@product_entry.combination_of_local_product), notice: "Пожалуйста, укажите любые расходы, которые используются для производства этого продукта." }
          else
            format.html { redirect_to product_entries_url, notice: "Product entry was successfully created." }
          end
          format.json { render :show, status: :created, location: @product_entry }
        else
          format.html { redirect_to request.referrer, notice: @product_entry.errors.messages }
          format.json { render json: @product_entry.errors, status: :unprocessable_entity }
        end
      end
    else
      excel_integration = ProductEntries::ImportExcel.run(
        excel_data: product_entry_params['excel_data'],
        product_category_id: product_entry_params['product_category_id'],
        storage_id: product_entry_params['storage_id'],
        price_in_percentage: product_entry_params['price_in_percentage'].to_f,
        delivery_from_counterparty_id: product_entry_params['delivery_from_counterparty_id']
      )
      redirect_to request.referrer, notice: "Success: #{excel_integration.errors.messages.values}"
    end
  end

  # PATCH/PUT /product_entries/1 or /product_entries/1.json
  def update
    authorize ProductEntry, :manage?

    respond_to do |format|
      if @product_entry.update(product_entry_params)
        if @product_entry.delivery_from_counterparty_id.present?
          format.html { redirect_to delivery_from_counterparty_url(@product_entry.delivery_from_counterparty), notice: "Product entry was successfully updated." }
        end

        format.html { redirect_to product_entries_url, notice: "Product entry was successfully updated." }
        format.json { render :show, status: :ok, location: @product_entry }
      else
        format.html { redirect_to request.referrer, notice: @product_entry.errors }
        format.json { render json: @product_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_entries/1 or /product_entries/1.json
  def destroy
    @product_entry.destroy

    respond_to do |format|
      if @product_entry.delivery_from_counterparty_id.present?
        format.html { redirect_to delivery_from_counterparty_url(@product_entry.delivery_from_counterparty), notice: "Product entry was successfully destroyed." }
      end

      format.html { redirect_to product_entries_url, notice: "Product entry was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product_entry
    @product_entry = ProductEntry.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def product_entry_params
    params.require(:product_entry).permit(:product_category_id, :local_entry, :excel_data, :buy_price, :sell_price, :price_in_percentage, :delivery_from_counterparty_id, :storage_id, :service_price, :provider_id, :product_id, :amount, :amount_sold, :total_paid, :total_price, :comment, :return)
  end
end
