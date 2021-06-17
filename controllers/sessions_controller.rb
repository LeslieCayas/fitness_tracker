get '/login' do
  erb :'/sessions/login', locals: { error_message: ''}
end

post '/sessions' do  # Login to website
  email = params[:email]
  password = params[:password]
  # user = find user function
  # if user and password are correct - redirect to welcome page showing ""
  user = find_user_by("email", email, nil)

  if user && BCrypt::Password.new(user['password']) == password
    session[:user_id] = user['id']
    redirect "/welcome"
  else
    erb :'/sessions/login', locals: { error_message: 'Incorrect password'}
  end


end 

get '/welcome' do
  #  puts current_user['id'] # shows id of current user (use this to put into table)

  erb :index, layout: :layout
end

delete '/sessions' do
  session[:user_id] = nil
  redirect '/'
end