class SalesController < ApplicationController
  before_action :set_sale, only: %i[ show edit update destroy toggle_status generate_pdf]

  include Pundit::Authorization
  # GET /sales or /sales.json
  def index
    @q = Sale.includes(:buyer, :user).ransack(params[:q])
    @sales =
      @q.result.filter_by_total_paid_less_than_price(params.dig(:q_other, :total_paid_less_than_price))
        .order(id: :desc)

    @sales_data = @sales
    @sales = @sales.page(params[:page]).per(70)
  end

  # GET /sales/1 or /sales/1.json
  def show
    @product_sells = @sale.product_sells
    @product_sell = ProductSell.new(sale_id: @sale.id)
    @products = Product.active.where(for_sale: true).order(:name)
    if (product_sells = @sale.product_sells).exists?
      price_in_usd = product_sells.last.product.price_in_usd
      @products = @products.where(price_in_usd: price_in_usd).order(:name)
    end
  end

  # GET /sales/new
  def new
    @sale = Sale.new
  end

  # GET /sales/1/edit
  def edit
  end

  # POST /sales or /sales.json
  def create
    @sale = Sale.new(sale_params)
    @sale.user_id = current_user.id
    respond_to do |format|
      if @sale.save
        format.html { redirect_to sales_url(@sale), notice: "Sale was successfully created." }
        format.json { render :show, status: :created, location: @sale }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales/1 or /sales/1.json
  def update
    respond_to do |format|
      if @sale.update(sale_params.merge(
          status: sale_params[:status].to_i,
          total_price: @sale.calculate_total_price(false)
        ))
        format.html { redirect_to sales_url, notice: "Sale was successfully updated." }
        format.json { render :show, status: :ok, location: @sale }
      else
        format.html { redirect_to request.referrer, notice: @sale.errors.messages.values }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales/1 or /sales/1.json
  def destroy
    @sale.destroy

    respond_to do |format|
      format.html { redirect_to sales_url, notice: "Sale was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def default_create
    buyer = Buyer.first
    sfs = Sale.new(buyer: buyer, user: current_user)
    if sfs.save
      redirect_to sale_url(sfs), notice: 'Теперь добавьте продажу товаров'
    else
      redirect_to request.referrer, notice: "Something went wrong"
    end
  end

  def toggle_status
    authorize Sale, :manage?

    @sale.update(status: @sale.closed? ? 0 : 1)
    redirect_to request.referrer, notice: 'Successfully updated'
  end

  def generate_pdf
    authorize Sale, :access?

    ProductSells::GenerateReceipt.run(sale: @sale)
    redirect_to sales_path, notice: 'SUCCESS'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_sale
    @sale = Sale.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def sale_params
    params.require(:sale).permit(:total_paid, :payment_type, :buyer_id, :total_price, :comment, :user_id, :status, :discount_price)
  end
end
