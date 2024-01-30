class ProductsController < ApplicationController
  before_action :set_product, only: %i[ toggle_active show edit update destroy calculate_product_remaining]

  # GET /products or /products.json
  def index
    @q = Product.ransack(params[:q])
    @products = @q.result.order(active: :desc).order(name: :asc).page(params[:page]).per(70)
    @product_categories = ProductCategory.all
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @random_code = Product.generate_code
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to request.referrer, notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, product: @product, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to products_path, notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end
  Product.where('buy_price > ?', 2000).update_all(price_in_usd: false)

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def toggle_active
    @product.toggle(:active).save
    redirect_to products_url, notice: "Successfully updated"
  end

  def calculate_product_remaining
    calculate_product_remaining = @product.calculate_product_remaining

    render json: { calculate_product_remaining: calculate_product_remaining }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def product_params
    params.require(:product).permit(:name, :for_sale, :local, :price_in_usd, :sell_price, :buy_price, :unit, :product_category_id, :initial_remaining, :code)
  end
end
