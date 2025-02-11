require "rails_helper"

RSpec.describe "Products API", type: :request do

  let!(:products) { FactoryBot.create_list(:product, 3) }
  let(:product_id) { products.first.id }

  let(:headers) { { "Content-Type": "application/json" } }

  describe "GET /api/products" do
    before { get "/api/v1/products", headers: headers }

    it "return all the products" do
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe "GET /api/v1/products/:id" do
    context "when the product exists" do
      before { get "/api/v1/products/#{product_id}", headers: headers }

      it "return the product" do
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['id']).to eq(product_id)
      end
    end

    context "when the product doesn't exists" do
      before { get "/api/v1/products/999999", headers: headers }

      it "return 404" do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "POST /api/v1/products" do
    let(:valid_attributes) { { name: "New Producto", price: 25.99, stock: 10 }.to_json }

    context "when the request is valid" do
      it "creates a new product" do
        expect {
          post "/api/v1/products", params: valid_attributes, headers: headers
        }.to change(Product, :count).by(1)

        expect(response).to have_http_status(201)
      end
    end

    context "when the request is not valid" do
      let(:invalid_attributes) { { name: nil, price: nil, stock: nil }.to_json }

      it "return 422" do
        post "/api/v1/products", params: invalid_attributes, headers: headers
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "PUT /api/v1/products/:id" do
    let(:update_attributes) { { name: "Product Updated" }.to_json }

    context "when the product exists" do
      before { put "/api/v1/products/#{product_id}", params: update_attributes, headers: headers }

      it "update the product" do
        expect(response).to have_http_status(200)
        expect(Product.find(product_id).name).to eq("Product Updated")
      end
    end

    context "when the product does not exists" do
      before { put "/api/v1/products/999999", params: update_attributes, headers: headers }

      it "return 404" do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "DELETE /api/v1/products/:id" do
    context "when the product exists" do
      it "delete the product" do
        expect {
          delete "/api/v1/products/#{product_id}", headers: headers
        }.to change(Product, :count).by(-1)

        expect(response).to have_http_status(204)
      end
    end

    context "when the product doesn't exists" do
      before { delete "/api/v1/products/999999", headers: headers }

      it "return 404" do
        expect(response).to have_http_status(404)
      end
    end
  end
end