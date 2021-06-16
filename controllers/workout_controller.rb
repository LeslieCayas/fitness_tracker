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
  insert_query = "INSERT INTO workouts(user_id, workout_name) VALUES($1, $2)"
  insert_sql_params = [current_user['id'], params[:workout_name]]
  results = run_sql(insert_query, insert_sql_params)

  select_query = "SELECT * FROM workouts WHERE id = (SELECT max(id) FROM workouts)"
  select_results = run_sql(select_query)
  redirect "/workouts/#{select_results[0]['id']}"
end

get '/workouts/:id' do |id|     # Read individual selected workout
  query = "SELECT workouts.id AS workout_id, user_id, workout_name, exercises.id AS exercise_id, name, image_url, weight, sets, reps FROM workouts LEFT JOIN exercises ON workouts.id = exercises.workout_id WHERE workout_id = $1 ORDER BY exercise_id ASC"
  sql_params = [id]
  results = run_sql(query, sql_params)

  erb :'workouts/show_workout', locals: {individual_workout: results}
end

get '/workouts/:id/add' do |id| 
  query = "SELECT * FROM workouts WHERE id = $1"
  sql_params = [id]
  results = run_sql(query, sql_params)

  erb :'workouts/add_exercise_to_workout', locals: {individual_workout: results[0]}
end

post '/workouts/:id' do |id|
  query = "INSERT INTO exercises(workout_id, name, image_url, weight, reps, sets) VALUES($1,$2,$3,$4,$5,$6)"
  sql_params = [id, params[:exercise], params[:image_url], params[:weight], params[:reps], params[:sets]]
  results = run_sql(query, sql_params)
  redirect "workouts/#{id}"
end

get '/workouts/:workout_id/:exercise_id/edit' do |workout_id, exercise_id|
  query = "SELECT workouts.id AS workout_id, user_id, workout_name, exercises.id AS exercise_id, name, image_url, weight, sets, reps FROM workouts LEFT JOIN exercises ON workouts.id = exercises.workout_id WHERE workout_id = $1"
  sql_params = [workout_id]
  results = run_sql(query, sql_params)


  erb :'workouts/update', locals: {individual_workout: results[0]}
end


get '/workouts/:workout_id/:exercise_id' do |workout_id, exercise_id|
  query = "SELECT * FROM exercises WHERE id = $1"
  sql_params = [exercise_id]
  results = run_sql(query, sql_params)

  erb :'workouts/exercise', locals: {individual_exercise: results[0]}
end

put '/workouts/:workout_id/:exercise_id' do |workout_id, exercise_id|
  query = "UPDATE exercises SET name = $1, image_url = $2, weight = $3, reps = $4, sets = $5 WHERE id = $6"
  sql_params = [params[:exercise], params[:image_url], params[:weight], params[:reps], params[:sets], exercise_id]
  results = run_sql(query, sql_params)
  redirect "workouts/#{workout_id}/#{exercise_id}"
end

# select user_id, workout_name, name, image_url, weight, reps, sets FROM workouts JOIN exercises ON workouts.id = exercises.workout_id WHERE workout_id = 15

delete '/workouts/:workout_id/:exercise_id' do |workout_id, exercise_id|
  query = "DELETE FROM exercises WHERE id = $1"
  sql_params = [exercise_id]
  run_sql(query, sql_params)

  redirect "workouts/#{workout_id}"
end