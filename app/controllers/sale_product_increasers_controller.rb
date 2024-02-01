# protsess proizvodstvo
class SaleProductIncreasersController < ApplicationController
  before_action :set_sale_product_increaser, only: %i[ show edit update destroy ]

  # GET /sale_product_increasers or /sale_product_increasers.json
  def index
    @q = SaleProductIncreaser.ransack(params[:q])
    @sale_product_increasers = @q.result.order(id: :desc)
    @sale_product_increasers_data = @sale_product_increasers
    @sale_product_increasers = @sale_product_increasers.page(params[:page]).per(40)

    if !params.dig(:q_other, :show_only_for_sales).nil?
      value = params.dig(:q_other, :show_only_for_sales).to_sym
      show_sale = (value == :true)
      if show_sale
        @sale_product_increasers = SaleProductIncreaser.joins(:product).where(products: {for_sale: true})
      else
        @sale_product_increasers = @sale_product_increasers.joins(:product).where(products: {for_sale: false})
      end
    end
  end

  # GET /sale_product_increasers/1 or /sale_product_increasers/1.json
  def show
  end

  # GET /sale_product_increasers/new
  def new
    @sale_product_increaser = SaleProductIncreaser.new
  end

  # GET /sale_product_increasers/1/edit
  def edit
  end

  # POST /sale_product_increasers or /sale_product_increasers.json
  def create
    @sale_product_increaser = SaleProductIncreaser.new(sale_product_increaser_params)
    @sale_product_increaser.user_id = current_user.id
    respond_to do |format|
      if @sale_product_increaser.save
        format.html { redirect_to sale_product_increasers_url, notice: "Sale product increaser was successfully created." }
        format.json { render :show, status: :created, location: @sale_product_increaser }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sale_product_increaser.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sale_product_increasers/1 or /sale_product_increasers/1.json
  def update
    respond_to do |format|
      if @sale_product_increaser.update(sale_product_increaser_params)
        format.html { redirect_to sale_product_increasers_url, notice: "Sale product increaser was successfully updated." }
        format.json { render :show, status: :ok, location: @sale_product_increaser }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sale_product_increaser.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sale_product_increasers/1 or /sale_product_increasers/1.json
  def destroy
    @sale_product_increaser.destroy

    respond_to do |format|
      format.html { redirect_to sale_product_increasers_url, notice: "Sale product increaser was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale_product_increaser
      @sale_product_increaser = SaleProductIncreaser.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sale_product_increaser_params
      params.require(:sale_product_increaser).permit(:product_id, :amount, :user_id, :comment)
    end
end
