get '/sign_up' do
  erb :'/users/sign_up', layout: :layout
end

post '/users' do
  email = params["email"]
  user = params["username"]
  password = params["password"]
  create_user(email, user, password)

  redirect '/'
  erb :index
end