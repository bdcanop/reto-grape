module Products
  class API < Grape::API
    version "v1"
    format :json
    prefix :api

    resource :products do
      get do
        Product.all
      end

      get ":id" do
        Product.find(params[:id])
      end

      params do
        requires :name, type: String, desc: "Product name"
        requires :price, type: BigDecimal, desc: "Product price"
        requires :stock, type: Integer, desc: "Quantity of stock"
      end
      post do
        Product.create!(declared(params))
      end

      params do
        optional :name, type: String, desc: "New Product name"
        optional :price, type: BigDecimal, desc: "New Product price"
        optional :stock, type: Integer, desc: "New Quantity of stock"
      end
      put ":id" do
        product = Product.find(params[:id])
        product.update!(declared(params, include_missing: false))
        product
      end

      delete ":id" do
        Product.find(params[:id]).destroy
        status 204
      end
    end
  end
end