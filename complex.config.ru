require 'sinatra'

require_relative 'app/controllers/products_controller'
require_relative 'app/controllers/orders_controller'

use ProductsController
run OrdersController
