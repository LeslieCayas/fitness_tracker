get '/login' do
  erb :'/sessions/login'
end

post '/sessions' do  # Login to website
  email = params["email"]
  password = params["password"]
  # user = find user function
  # if user and password are correct - redirect to welcome page showing ""
end 

get '/welcome' do
  erb :index, layout: :layout
end