class OrdersController < Sinatra::Base

  get '/orders' do
    "Order Index"
  end

  get '/orders/:id' do
    "Order #{params[:id]} Show"
  end

end
