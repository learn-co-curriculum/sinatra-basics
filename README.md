# Sinatra Basics

## Objectives

1. Basic Sinatra Application structure.
2. The routing DSL basics of `get`.
3. Mounting a Controller.
4. Multi-Controller Application structure.
5. Mounting multiple controllers

## The Sinatra DSL

Any application that requires the `sinatra` library will get access to methods like: `get` and `post`. These methods provide the ability to instantly transform a ruby application into an application that can respond to HTTP requests.

## Basic Sinatra Applications

First, make sure sinatra is installed by running `gem install sinatra` in your terminal.

The simplest Sinatra application would be:

File: `sinatra_basic.rb`
```ruby
require 'sinatra'

get '/' do
  "Hello, World!"
end
```

You could start this web application by running `ruby sinatra_basic.rb`. You'll see something similar to:

```
$ ruby sinatra_basic.rb
== Sinatra (v1.4.6) has taken the stage on 4567 for development with backup from Thin
Thin web server (v1.6.3 codename Protein Powder)
Maximum connections set to 1024
Listening on localhost:4567, CTRL+C to stop
```

This is telling us that Sinatra has started a web application running on your computer listening to HTTP requests at port `4567`, the Sinatra default. If you start this application and navigate to http://localhost:4567 you'll see "Hello, World!" in your browser. Go back to your terminal running the Sinatra application and stop it by typing `CTRL+C`. You should see:

```
Listening on localhost:4567, CTRL+C to stop
^CStopping ...
Stopping ...
== Sinatra has ended his set (crowd applauds)
[00:01:11] (wip-lesson) what-is-sinatra
$
```

This is the most basic Sinatra application structure and is actually pretty uncommon. More commonly, Sinatra is used in a modular style encapsulated by Controller Classes and booted via the `config.ru` Rack convention.

## Modular Sinatra Applications

Web applications, even simple Sinatra ones, tend to require a certain degree of complexity. To handle this, Sinatra is more commonly used through the Modular Sinatra Pattern.

### `config.ru`

The first new convention this pattern introduces is a `config.ru` file. The purpose of `config.ru` is to detail to Rack the environment requirements of the application and start the application.

A common 'config.ru' might look like:

File: `config.ru`
```ruby
require 'sinatra'

require_relative './sinatra_modular.rb'

run Application
```

In the first line of `config.ru` we load the Sinatra library. The second line requires our application file, defined in `sinatra_modular.rb`, which we will discuss in a moment. The last line of the file uses `run` to start the application represented by the ruby class `Application`, which is defined in `sinatra_modular.rb`.

### Sinatra Controllers: `sinatra_modular.rb`

`config.ru` requires a valid Sinatra Controller to `run`. A Sinatra Controller is simply a ruby class that inherits from `Sinatra::Base`. This inheritance transforms into a web application by giving it a Rack-compatible interface behind the scenes via the Sinatra framework. Open `sinatra_modular.rb`

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

#### Mounting Multiple Controllers in `config.ru`.

Now that our application logic spans more than one controller class, our `config.ru` that starts our application becomes a bit more complicated.

First, our environment must load both controller files.

`config.ru`:
```ruby
require 'sinatra'

require_relative 'app/controllers/products_controller'
require_relative 'app/controllers/orders_controller'
```

Then, we must mount both classes. However, only one class can be specificed to be `run`, the other class must be loaded as something called MiddleWare that we won't get into, suffice to say, you simply `use` it instead of `run`.

`config.ru`:
```ruby
require 'sinatra'

require_relative 'app/controllers/products_controller'
require_relative 'app/controllers/orders_controller'

use ProductsController
run OrdersController
```

Which classes you `use` or `run` matter, but we won't worry about that now, just make sure you only ever `run` one class and the rest our loaded via `use`.

You can run that complex application with `rackup complex.config.ru`, explicitly providing the Rackup file to use (`config.ru` is the default). Once the application loads and is listening on port 4567, navigate to http://localhost:4567/products , http://localhost:4567/products/42, http://localhost:4567/orders , and http://localhost:4567/orders/2600 to see the application in action. Stop it with `CTRL+C`

## Resources

* [Blake Mizerany - Ruby Learning Interview](http://rubylearning.com/blog/2009/08/11/blake-mizerany-how-do-i-learn-and-master-sinatra/)
* [Companies Using Sinatra](http://www.sinatrarb.com/wild.html)
