get '/' do
  redirect '/welcome'
  erb :index
end

get '/workouts' do              # Read list of user's workouts
  query = "SELECT * FROM workouts WHERE user_id = $1"
  sql_params = [current_user['id']]
  results = run_sql(query, sql_params)
  
  erb :'workouts/show', locals: {results: results}
end

get '/workouts/create' do       # Read CREATE form
  erb :'workouts/create_workout'
end

post '/workouts' do

  query = "INSERT INTO workouts(user_id, workout_name) VALUES($1, $2)"
  sql_params = [current_user['id'], params[:workout_name]]
  results = run_sql(query, sql_params)
  redirect "/"
end

get '/workouts/:id' do |id|     # Read individual selected workout

  erb :'workouts/show_workout'
end

post '/workouts/:id' do |id|
  
end