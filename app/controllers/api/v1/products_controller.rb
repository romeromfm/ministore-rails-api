class Api::V1::ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    def index
      render json: Product.order(created_at: :desc), status: 200
    end

    def show
      render json: @product, status: 200
    end

    def new
      @product = Product.new
    end

    def edit
    end

    def create
      @product = Product.new(product_params)

      if @product.save
        render json: @product, status: :created
      else
        render json: @product.errors, status: :unprocessable_entity
      end
    end

    def update
      if @product.update(product_params_update)
        render json: @product, status: :ok
      else
        render json: @product.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @product.destroy
      render json: {status: 'deleted'}, status: :ok
    end

    private
      def set_product
        @product = Product.find(params[:id])
      end

      def product_params
        params.require(:product).permit(:id, :title, :description, :image, :price, :active)
      end

      def product_params_update
        params.permit(:id, :title, :description, :image, :price, :active)
        #require(:product) removed because angular update does not work with it
      end

      def not_found
        render json: {status: 404, errors: 'Not found'}
      end
end
