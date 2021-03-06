get '/' do
  redirect '/welcome'
  erb :index
end

get '/about' do
  erb :about
end

get '/workouts' do              # Read list of user's workouts
  results = select_user_workouts(current_user['id'])

  erb :'workouts/show_list', locals: {results: results}
end

get '/workouts/create' do       # Read CREATE form

  erb :'workouts/create'
end

post '/workouts' do
  create_workout = new_workout_name(current_user['id'], params[:workout_name])
  new_workout_entry = select_new_workout()

  redirect "/workouts/#{new_workout_entry[0]['id']}"
end

get '/workouts/:workout_id' do |workout_id|     # Read individual selected workout
  results = select_joint_table_by_workout_id(workout_id)
  error_message = check_user()

  erb :'workouts/show_workout', locals: {individual_workout: results, workout_id: workout_id, error_message: error_message}
end

get '/workouts/:id/add' do |workout_id| 
  results = select_user_workouts(current_user['id'])

  if session[:user_id]
    results = select_user_workouts(current_user['id'])
    error_message = ""
  else
    error_message = "You do not have access to this. Please log in."
  end
  
  erb :'workouts/exercises/create', locals: {workout_id: workout_id, error_message: error_message}
end

post '/workouts/:id' do |id|
  results = new_exercise(id, params[:exercise_name], params[:image_url], params[:weight], params[:reps], params[:sets], params[:notes])

  redirect "/workouts/#{id}"
end

get '/workouts/:workout_id/:exercise_id/edit' do |workout_id, exercise_id|
  results = select_joint_table_by_workout_id(workout_id)
  exercise = select_user_exercises(exercise_id)

  erb :'workouts/exercises/update', locals: {individual_workout: results[0]}
end


get '/workouts/:workout_id/:exercise_id' do |workout_id, exercise_id|
  results = select_user_exercises(exercise_id)

  erb :'workouts/exercises/show', locals: {individual_exercise: results[0]}
end

put '/workouts/:workout_id/:exercise_id' do |workout_id, exercise_id|
  puts params[:image_url]

  results = update_exercise(params[:exercise_name], params[:image_url], params[:weight], params[:reps], params[:sets], params[:notes], params[:exercise_id])
  redirect "/workouts"
end

delete '/workouts/:workout_id/:exercise_id' do |workout_id, exercise_id|
  delete_record_with_id("exercises", exercise_id)

  redirect "workouts/#{workout_id}"
end

delete '/workouts/:workout_id' do |workout_id|
  delete_record_with_id("workouts", workout_id)
  delete_exercises_from_workouts(workout_id)
  redirect "/workouts"
end