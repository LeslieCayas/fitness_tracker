get '/sign_up' do
  erb :'/users/sign_up', layout: :layout, locals: {message: ''}
end

post '/users' do
  email = params["email"]
  user = params["username"]
  password = params["password"]
  message = create_user(email, user, password)
  puts message

  if message == "Please use a valid email address"
    erb :'/users/sign_up', locals: {message: message}
  else
    redirect '/welcome'
  end
end