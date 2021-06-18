get '/' do
  redirect '/welcome'
  erb :index
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
  results = select_joint_table_by(workout_id, nil)
  puts is_logged_in?
  error_message = check_user()
  puts error_message
  erb :'workouts/show_workout', locals: {individual_workout: results, workout_id: workout_id, error_message: error_message}
end

get '/workouts/:id/add' do |id| 
  results = select_user_workouts(current_user['id'])

  erb :'workouts/exercises/create', locals: {individual_workout: results[0], id: id}
end

post '/workouts/:id' do |id|
  results = new_exercise(id, params[:exercise_name], params[:image_url], params[:weight], params[:reps], params[:sets], params[:notes])
  redirect "/workouts/#{id}"
end

get '/workouts/:workout_id/:exercise_id/edit' do |workout_id, exercise_id|
  results = select_joint_table_by(workout_id, nil)
  exercise = select_user_exercises(exercise_id)

  erb :'workouts/exercises/update', locals: {individual_workout: results[0]}
end


get '/workouts/:workout_id/:exercise_id' do |workout_id, exercise_id|
  results = select_user_exercises(exercise_id)

  erb :'workouts/exercises/show', locals: {individual_exercise: results[0]}
end

put '/workouts/:workout_id/:exercise_id' do |workout_id, exercise_id|
  # binding.irb
  results = update_exercise(params[:exercise_name], params[:image_url], params[:weight], params[:reps], params[:sets], params[:notes], params[:exercise_id])
  redirect "/workouts"
end

delete '/workouts/:workout_id/:exercise_id' do |workout_id, exercise_id|
  delete_record_with_id("exercises", exercise_id)

  redirect "workouts/#{workout_id}"
end

delete '/workouts/:workout_id' do |workout_id|
  delete_record_with_id("workouts", workout_id)

  redirect "/workouts"
end

# columns = ["exercise_name", "image_url", "weight", "reps", "sets", "notes"]
# params = params[:exercise], params[:image_url], params[:weight], params[:reps], params[:sets], params[:notes], params[:exercise_id]

# params.map do |param|
#   if param.empty?
#     param = 
#   else
#     param = param
#   end
# end

# columns = ["exercise_name", "image_url", "weight", "reps", "sets", "notes"]
# key = ["name", "image_url", "weight", "reps", "sets", "notes"]

# params = [params["exercise_name"], params["image_url"], params["weight"], params["reps"], params["sets"], params["notes"], params["exercise_id"]]

# query = "UPDATE exercises SET name=$1, image_url=$2, weight=$3, reps=$4, sets=$5, notes=$6 WHERE id = $7"
# exercise = select_user_exercises(exercise_id)
# params.map do |param|
#   if param.empty?
#     param = exercise[0][key(param).to_s]
#   end
# end

# exercise = select_user_exercises(exercise_id)
# params = [params["exercise_name"], params["image_url"], params["weight"], params["reps"], params["sets"], params["notes"], params["exercise_id"]]
# params = [params["exercise_name"], params["image_url"], params["weight"], "", params["sets"], params["notes"], params["exercise_id"]]
# params = [params["exercise_name"], params["image_url"], params["weight"], exercise[0]["reps"], params["sets"], params["notes"], params["exercise_id"]]

# params.map do |param|
#   if param.empty?
#     param = exercise[0][key(param).to_s]
#   end
# end
