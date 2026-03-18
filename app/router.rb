require 'erb'
require 'json'
require_relative 'utils/auth_helper'
require_relative 'models/user'
require_relative 'models/product'
require_relative 'models/category'
require_relative 'models/order'
require_relative 'helpers/view_helper'

class Router
  def initialize(env)
    @req = Rack::Request.new(env)
  end

  def route
    case @req.path
    when '/'
      render_view('home')
    when '/shop'
      render_view('shop')
    when '/product'
      render_view('product')
    when '/categories'
      render_view('categories')
    when '/about'
      render_view('about')
    when '/contact'
      render_view('contact')
    when '/terms'
      render_view('terms')
    when '/cart'
      render_view('cart')
    when '/cart/add'
      handle_cart_add if @req.post?
    when '/cart/remove'
      handle_cart_remove
    when '/cart/update'
      handle_cart_update if @req.post?
    when '/checkout'
      if @req.post?
        handle_checkout
      else
        render_view('checkout')
      end
    when '/order-success'
      render_view('order_success')
    when '/login'
      if @req.post?
        handle_login
      else
        render_view('login', layout: false)
      end
    when '/logout'
      handle_logout
    when '/admin'
      require_auth { render_view('admin/dashboard') }
    when '/admin/products'
      require_auth { render_view('admin/products') }
    when '/admin/products/new'
      require_auth do
        if @req.post?
          handle_product_create
        else
          render_view('admin/products_new')
        end
      end
    when '/admin/products/edit'
      require_auth do
        id = @req.params['id']
        product = Product.find(id)
        if product
          render_view('admin/products_edit', { product: product })
        else
          redirect_to('/admin/products')
        end
      end
    when '/admin/products/update'
      require_auth { handle_product_update if @req.post? }
    when '/admin/products/delete'
      require_auth { handle_product_delete }
    when '/admin/categories'
      require_auth do
        if @req.post?
          Category.create(name: @req.params['name'])
          redirect_to('/admin/categories')
        else
          render_view('admin/categories')
        end
      end
    when '/admin/categories/delete'
      require_auth do
        Category.delete(@req.params['id'])
        redirect_to('/admin/categories')
      end
    when '/admin/orders'
      require_auth { render_view('admin/orders') }
    when '/admin/orders/view'
      require_auth do
        id = @req.params['id']
        order = Order.find(id)
        if order
          render_view('admin/order_view', { order: order })
        else
          redirect_to('/admin/orders')
        end
      end
    when '/admin/orders/update'
      require_auth { handle_order_update }
    else
      [404, { 'content-type' => 'text/html' }, ['Halaman Tidak Ditemukan']]
    end
  end

  private

  def require_auth
    if AuthHelper.authenticated?(@req)
      yield
    else
      redirect_to('/login')
    end
  end

  def handle_login
    email = @req.params['email']
    password = @req.params['password']
    user = User.authenticate(email, password)

    if user
      token = AuthHelper.encode_token({ email: user.email, name: user.name, id: user.id.to_s })
      res = Rack::Response.new
      res.redirect('/admin')
      res.set_cookie('auth_token', { value: token, path: '/', httponly: true })
      res.finish
    else
      render_view('login', error: 'Email atau password salah', layout: false)
    end
  end

  def handle_logout
    res = Rack::Response.new
    res.redirect('/login')
    res.delete_cookie('auth_token')
    res.finish
  end

  def redirect_to(path)
    [302, { 'location' => path }, []]
  end

  def handle_product_create
    name = @req.params['name']
    category_id = @req.params['category_id']
    price = @req.params['price'].to_f
    stock = @req.params['stock'].to_i
    description = @req.params['description']
    
    image_url = nil
    if @req.params['image'] && @req.params['image'][:tempfile]
      require_relative 'utils/cloudinary_helper'
      image_url = CloudinaryHelper.upload(@req.params['image'][:tempfile].path)
    end

    Product.create(
      name: name,
      category_id: category_id,
      price: price,
      stock: stock,
      description: description,
      image_url: image_url
    )
    redirect_to('/admin/products')
  end

  def handle_product_delete
    id = @req.params['id']
    if id
      product = Product.find(id)
      if product && product.image_url
        require_relative 'utils/cloudinary_helper'
        CloudinaryHelper.delete(product.image_url)
      end
      Product.delete(id)
    end
    redirect_to('/admin/products')
  end

  def handle_product_update
    id = @req.params['id']
    name = @req.params['name']
    category_id = @req.params['category_id']
    price = @req.params['price'].to_f
    stock = @req.params['stock'].to_i
    description = @req.params['description']
    
    update_data = {
      name: name,
      category_id: category_id,
      price: price,
      stock: stock,
      description: description
    }

    if @req.params['image'] && @req.params['image'][:tempfile]
      require_relative 'utils/cloudinary_helper'
      
      # Delete old image if exists
      product = Product.find(id)
      CloudinaryHelper.delete(product.image_url) if product && product.image_url
      
      update_data[:image_url] = CloudinaryHelper.upload(@req.params['image'][:tempfile].path)
    end

    Product.update(id, update_data)
    redirect_to('/admin/products')
  end

  def handle_order_update
    id = @req.params['id']
    status = @req.params['status']
    resi = @req.params['resi']
    Order.update_status(id, status, resi) if id && status
    redirect_to('/admin/orders')
  end

  def handle_cart_add
    product_id = @req.params['product_id']
    quantity = @req.params['quantity'].to_i
    
    @req.session['cart'] ||= {}
    @req.session['cart'][product_id] = (@req.session['cart'][product_id] || 0) + quantity
    
    redirect_to('/cart')
  end

  def handle_cart_remove
    product_id = @req.params['id']
    @req.session['cart']&.delete(product_id)
    redirect_to('/cart')
  end

  def handle_cart_update
    product_id = @req.params['product_id']
    quantity = @req.params['quantity'].to_i
    if quantity > 0
      @req.session['cart'][product_id] = quantity
    else
      @req.session['cart']&.delete(product_id)
    end
    redirect_to('/cart')
  end

  def handle_checkout
    cart = @req.session['cart'] || {}
    return redirect_to('/shop') if cart.empty?

    items = []
    total = 0
    cart.each do |id, qty|
      product = Product.find(id)
      if product && product.stock >= qty
        items << { product_id: product.id, name: product.name, price: product.price, quantity: qty }
        total += product.price * qty
        # Update stock
        Product.update(id, { stock: product.stock - qty })
      end
    end

    if items.any?
      order_data = {
        customer_name: @req.params['customer_name'],
        contact: @req.params['contact'],
        customer_email: @req.params['customer_email'],
        address: @req.params['address'],
        items: items,
        total_price: total
      }
      
      result = Order.create(order_data)
      
      # Send Receipt Email via Brevo
      if result && result.inserted_id
        require_relative 'utils/email_helper'
        order = Order.find(result.inserted_id.to_s)
        EmailHelper.send_receipt(order) if order
      end

      @req.session['cart'] = {}
      redirect_to('/order-success')
    else
      redirect_to('/cart')
    end
  end

  def render_view(view, locals = {}, layout: true)
    view_path = File.expand_path("../views/#{view}.html.erb", __FILE__)
    unless File.exist?(view_path)
      return [404, { 'content-type' => 'text/html' }, ["Tampilan tidak ditemukan: #{view}"]]
    end

    # Extract locals into instance variables for ERB access if needed, 
    # or just use the hash in the binding.
    # To make locals available as variables in ERB, we can do this:
    locals.each { |k, v| instance_variable_set("@#{k}", v) }

    template = File.read(view_path)
    main_content = ERB.new(template).result(binding)

    if layout
      layout_path = File.expand_path("../views/layout.html.erb", __FILE__)
      layout_template = File.read(layout_path)
      final_content = ERB.new(layout_template).result(binding)
    else
      final_content = main_content
    end

    [200, { 'content-type' => 'text/html' }, [final_content]]
  end
end
