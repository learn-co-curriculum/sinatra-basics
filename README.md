# Sinatra Basics

## Objectives

1. Modular Sinatra Applications
2. Mounting a Controller
4. Multi-Controller Application structure.
5. Mounting multiple controllers

## Modular Sinatra Applications

Web applications, even simple Sinatra ones, tend to require a certain degree of complexity. To handle this, Sinatra is more commonly used through the Modular Sinatra Pattern (over the single file `app.rb`).

### `config.ru`

The first new convention this pattern introduces is a `config.ru` file. The purpose of `config.ru` is to detail to Rack the environment requirements of the application and start the application.

A common 'config.ru' might look like:

File: `config.ru`
```ruby
require 'sinatra'

require_relative './app.rb'

run Application
```

In the first line of `config.ru` we load the Sinatra library. The second line requires our application file, defined in `app.rb`, which we will discuss in a moment. The last line of the file uses `run` to start the application represented by the ruby class `Application`, which is defined in `app.rb`.

### Sinatra Controllers: `app.rb`

`config.ru` requires a valid Sinatra Controller to `run`. A Sinatra Controller is simply a ruby class that inherits from `Sinatra::Base`. This inheritance transforms into a web application by giving it a Rack-compatible interface behind the scenes via the Sinatra framework. Open `app.rb`

```ruby
class Application < Sinatra::Base

  get '/' do
    "Hello, World!"
  end

end
```

We simply create a new class `Application` and inherit from `Sinatra::Base`. Our class constant could have been anything descriptive of the functionality provided by the class. The classes that inherit from `Sinatra::Base` and define the HTTP interface for our application are called Controllers.

In a single controller application, a single file defining the controller, like `app.rb`, will suffice. That controller will define every single URL and response of our application.

Controllers define an HTTP method using the sinatra routing DSL provided by methods like `get` and `post`. When you enclose these methods within a ruby class that is a Sinatra Controller, these HTTP routes are scoped and attached to the controller.

The final step in creating a controller is mounting it in `config.ru`. Mounting a Controller means telling Rack that part of your web application is defined within the following class. We do this in config.ru by using `run Application` where `run` is the mounting method and `Application` is the controller class that inherits from `Sinatra::Base` and is defined in a previously required file.

#### Multiple Controller Applications

Often applications need to respond to multiple URLs relating to a single concept in the application.

In an e-commerce application, the `/products` URL, would relate to requests to view products. `/products/1` would represent requesting information about the first product. However URLs around `/orders` would relate to requests to view a customer's order history. `/orders/1` would represent requesting information about the first order.

To separate these domain concepts in our code, we'd actually code the responses to such a grouping of URLs in separate controllers. Every controller in our application should follow the Single Responsibility Principal, only encapsulating logic relating to a singular entity in our application domain.

You can imagine a controller `ProductsController`, defined in `app/controllers/products_controller.rb`.

```ruby
class ProductsController < Sinatra::Base

  get '/products' do
    "Product Index"
  end

  get '/products/:id' do
    "Product #{params[:id]} Show"
  end

end
```

Don't worry about the specifics of how `get '/products/:id'` as a route functions, just know it provides the functionality of URLs that match the pattern `/products/1`, `/products/2`, `/products/10`, etc.

Similarly, we'd have `OrdersController` defined in `app/controllers/orders_controller.rb`/

```ruby
class OrdersController < Sinatra::Base

  get '/orders' do
    "Order Index"
  end

  get '/orders/:id' do
    "Order #{params[:id]} Show"
  end

end
```

#### Mounting Multiple Controllers in `complex.config.ru`.

Now that our application logic spans more than one controller class, our `complex.config.ru` that starts our application becomes a bit more complicated.

First, our environment must load both controller files.

`complex.config.ru`:
```ruby
require 'sinatra'

require_relative 'app/controllers/products_controller'
require_relative 'app/controllers/orders_controller'
```

Then, we must mount both classes. However, only one class can be specificed to be `run`, the other class must be loaded as something called MiddleWare that we won't get into, suffice to say, you simply `use` it instead of `run`.

`complex.config.ru`:
```ruby
require 'sinatra'

require_relative 'app/controllers/products_controller'
require_relative 'app/controllers/orders_controller'

use ProductsController
run OrdersController
```

Which classes you `use` or `run` matter, but we won't worry about that now, just make sure you only ever `run` one class and the rest our loaded via `use`.

You can run that complex application with `rackup complex.config.ru`, explicitly providing the Rackup file to use (`config.ru` is the default). Once the application loads and is listening on port 9292, navigate to http://localhost:9292/products , http://localhost:9292/products/42, http://localhost:9292/orders , and http://localhost:9292/orders/2600 to see the application in action. Stop it with `CTRL+C`

## Resources

* [Blake Mizerany - Ruby Learning Interview](http://rubylearning.com/blog/2009/08/11/blake-mizerany-how-do-i-learn-and-master-sinatra/)
* [Companies Using Sinatra](http://www.sinatrarb.com/wild.html)
