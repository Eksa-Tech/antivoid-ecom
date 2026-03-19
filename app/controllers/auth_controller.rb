module AuthController
  def handle_login
    email = @req.params['email']
    password = @req.params['password']
    user = User.authenticate(email, password)

    if user
      token = AuthHelper.encode_token({ 'user_id' => user.id.to_s })
      res = Rack::Response.new
      if user.role == 'admin'
        res.redirect('/admin')
      else
        res.redirect('/') # Or account page
      end
      res.set_cookie('auth_token', { value: token, path: '/', httponly: true })
      res.finish
    else
      render_view('login', error: 'Email atau password salah', layout: false)
    end
  end

  def handle_register
    name = @req.params['name']
    email = @req.params['email']
    password = @req.params['password']
    
    # Check if email exists
    if Database.collection(:users).find(email: email).first
      return render_view('register', error: 'Email sudah terdaftar', layout: false)
    end

    User.create({
      name: name,
      email: email,
      password: password,
      role: 'customer'
    })

    redirect_to('/login')
  end

  def handle_logout
    res = Rack::Response.new
    res.redirect('/login')
    res.delete_cookie('auth_token')
    res.finish
  end

  def handle_account_update
    user = AuthHelper.current_user(@req)
    if user
      name = @req.params['name']
      whatsapp = @req.params['whatsapp']
      address = @req.params['address']
      User.update(user.id.to_s, { name: name, whatsapp: whatsapp, address: address })
    end
    redirect_to('/account')
  end
end
