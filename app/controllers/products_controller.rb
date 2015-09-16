class ProductsController < Sinatra::Base

  get '/products' do
    "Product Index"
  end

  get '/products/:id' do
    "Product #{params[:id]} Show"
  end

end
