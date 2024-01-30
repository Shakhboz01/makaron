class DeliveryFromCounterpartiesController < ApplicationController
  before_action :set_delivery_from_counterparty, only: %i[ show edit update destroy toggle_status ]
  include Pundit::Authorization

  # GET /delivery_from_counterparties or /delivery_from_counterparties.json
  def index
    @q = DeliveryFromCounterparty.ransack(params[:q])
    @delivery_from_counterparties =
      @q.result.filter_by_total_paid_less_than_price(params.dig(:q_other, :total_paid_less_than_price))
        .order(id: :desc)

    @delivery_from_counterparties_data = @delivery_from_counterparties
    @delivery_from_counterparties = @delivery_from_counterparties.page(params[:page]).per(70)
  end

  # GET /delivery_from_counterparties/1 or /delivery_from_counterparties/1.json
  def show
    @expenditures = @delivery_from_counterparty.expenditures
    @expenditures_data = @delivery_from_counterparty.expenditures
    @q = @delivery_from_counterparty.product_entries.ransack(params[:q])
    @product_entries = @q.result
    @storage = @delivery_from_counterparty.product_entries&.last&.storage_id
    @product_entry = ProductEntry.new(delivery_from_counterparty_id: @delivery_from_counterparty.id)
    @price_in_percentage = 0
    @products = Product.active.order(:name)
    if (product_entries = @delivery_from_counterparty.product_entries).exists?
      @price_in_percentage = product_entries.last.price_in_percentage
      @products = @products.where(for_sale: false).order(:name)
    end
  end

  # GET /delivery_from_counterparties/new
  def new
    @delivery_from_counterparty = DeliveryFromCounterparty.new
  end

  # GET /delivery_from_counterparties/1/edit
  def edit
    if params[:status]
      @delivery_from_counterparty.status = params[:status].to_i
      @delivery_from_counterparty.total_price = @total_price
    end
  end

  # POST /delivery_from_counterparties or /delivery_from_counterparties.json
  def create
    @delivery_from_counterparty = DeliveryFromCounterparty.new(delivery_from_counterparty_params)
    @delivery_from_counterparty.user_id = current_user.id
    respond_to do |format|
      if @delivery_from_counterparty.save
        format.html { redirect_to new_product_entry_path(delivery_from_counterparty_id: @delivery_from_counterparty.id, local_entry: false), notice: "Delivery from counterparty was successfully created." }
        format.json { render :show, status: :created, location: @delivery_from_counterparty }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @delivery_from_counterparty.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /delivery_from_counterparties/1 or /delivery_from_counterparties/1.json
  def update
    respond_to do |format|
      if @delivery_from_counterparty.update(delivery_from_counterparty_params.merge(
          status: delivery_from_counterparty_params[:status].to_i,
          total_price: @delivery_from_counterparty.calculate_total_price(false)
         ))
        format.html { redirect_to delivery_from_counterparties_url, notice: "Delivery from counterparty was successfully updated." }
        format.json { render :show, status: :ok, location: @delivery_from_counterparty }
      else
        format.html { redirect_to request.referrer }
        format.json { render json: @delivery_from_counterparty.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /delivery_from_counterparties/1 or /delivery_from_counterparties/1.json
  def destroy
    @delivery_from_counterparty.destroy

    respond_to do |format|
      format.html { redirect_to delivery_from_counterparties_url, notice: "Delivery from counterparty was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def default_create
    provider = Provider.first
    sfs = DeliveryFromCounterparty.new(provider: provider, user_id: current_user.id)
    if sfs.save
      redirect_to delivery_from_counterparty_url(sfs), notice: "Теперь добавьте продажу товаров"
    else
      redirect_to request.referrer, notice: "Something went wrong"
    end
  end

  def toggle_status
    authorize DeliveryFromCounterparty, :manage?

    @delivery_from_counterparty.update(status: @delivery_from_counterparty.closed? ? 0 : 1)
    redirect_to request.referrer, notice: 'Successfully updated'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_delivery_from_counterparty
    @delivery_from_counterparty = DeliveryFromCounterparty.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def delivery_from_counterparty_params
    params.require(:delivery_from_counterparty).permit(:total_price, :status, :total_paid, :payment_type, :comment, :provider_id, :product_category)
  end
end
