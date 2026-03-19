module AdminController
  def handle_product_create
    name = @req.params['name']
    category_id = @req.params['category_id']
    price = @req.params['price'].to_f
    stock = @req.params['stock'].to_i
    description = @req.params['description']
    
    image_url = nil
    if @req.params['image'] && @req.params['image'][:tempfile]
      require_relative '../utils/cloudinary_helper'
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
        require_relative '../utils/cloudinary_helper'
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
      require_relative '../utils/cloudinary_helper'
      
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

  def handle_orders_export
    orders = Order.all
    csv_string = CSV.generate do |csv|
      csv << ['Order ID', 'Customer Name', 'Email', 'Total Price', 'Status', 'Date']
      orders.each do |o|
        csv << [o.id, o.customer_name, o.customer_email, o.total_price, o.status, o.created_at]
      end
    end

    [200, { 
      'content-type' => 'text/csv', 
      'content-disposition' => "attachment; filename=\"orders_#{Time.now.strftime('%Y%m%d')}.csv\"" 
    }, [csv_string]]
  end

  def handle_banner_add
    image_url = nil
    if @req.params['image']
      require_relative '../utils/cloudinary_helper'
      image_url = CloudinaryHelper.upload(@req.params['image'][:tempfile].path)
    end

    Banner.create({
      title: @req.params['title'],
      subtitle: @req.params['subtitle'],
      link: @req.params['link'],
      image_url: image_url,
      active: @req.params['active'] == 'on'
    })
    redirect_to('/admin/banners')
  end

  def handle_banner_delete
    id = @req.params['id']
    banner = Banner.find(id)
    if banner
      require_relative '../utils/cloudinary_helper'
      CloudinaryHelper.delete(banner.image_url) if banner.image_url
      Banner.delete(id)
    end
    redirect_to('/admin/banners')
  end
end
