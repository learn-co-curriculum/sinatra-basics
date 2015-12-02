# Sinatra Basics

## Objectives

1. Modular Sinatra Applications
2. Mounting a Controller

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

We simply create a new class `Application` and inherit from `Sinatra::Base`.Our class constant could have been anything descriptive of the functionality provided by the class. The classes that inherit from `Sinatra::Base` and define the HTTP interface for our application are called Controllers.

In a single controller application, a single file defining the controller, like `app.rb`, will suffice. That controller will define every single URL and response of our application.

Controllers define an HTTP method using the sinatra routing DSL provided by methods like `get` and `post`. When you enclose these methods within a ruby class that is a Sinatra Controller, these HTTP routes are scoped and attached to the controller.

The final step in creating a controller is mounting it in `config.ru`. Mounting a Controller means telling Rack that part of your web application is defined within the following class. We do this in config.ru by using `run Application` where `run` is the mounting method and `Application` is the controller class that inherits from `Sinatra::Base` and is defined in a previously required file.

The class named we defined in our application controller (`app.rb`) is just a normal Ruby class. We could have named it `MyToDoApp`:

```ruby
class MyToDoApp < Sinatra::Base

  get '/' do
    "Hello, World!"
  end

end
```

If this was our class name, we would need to change `config.ru` to run the appropriate class:

```ruby
run MyToDoApp
```

## Resources

* [Blake Mizerany - Ruby Learning Interview](http://rubylearning.com/blog/2009/08/11/blake-mizerany-how-do-i-learn-and-master-sinatra/)
* [Companies Using Sinatra](http://www.sinatrarb.com/wild.html)

<a href='https://learn.co/lessons/sinatra-basics' data-visibility='hidden'>View this lesson on Learn.co</a>
