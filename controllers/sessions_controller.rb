get '/login' do
  erb :'/sessions/login', locals: { error_message: ''}
end

post '/sessions' do  # Login to website
  email = params[:email]
  password = params[:password]
  user = find_user_by("email", email, nil)

  if user && BCrypt::Password.new(user['password']) == password
    session[:user_id] = user['id']
    redirect "/welcome"
  else
    erb :'/sessions/login', locals: { error_message: 'Incorrect password'}
  end

end 

get '/welcome' do
  erb :index, layout: :layout
end

delete '/sessions' do
  session[:user_id] = nil
  redirect '/'
end