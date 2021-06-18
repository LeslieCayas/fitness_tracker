def select_user_workouts(id)
  query = "SELECT * FROM workouts WHERE user_id = $1"
  sql_params = [id]
  run_sql(query, sql_params)
end

def select_user_exercises(id)
  query = "SELECT * FROM exercises WHERE id = $1"
  sql_params = [id]
  run_sql(query, sql_params)
end

def new_workout_name(current_user, workout_name_input)
  query = "INSERT INTO workouts(user_id, workout_name) VALUES($1, $2)"
  sql_params = [current_user, workout_name_input]
  run_sql(query, sql_params)
end

def select_new_workout()
  query = "SELECT * FROM workouts WHERE id = (SELECT max(id) FROM workouts)"
  run_sql(query)
end

def select_joint_table_by(workout_id, exercise_id)

  if workout_id
    query = "SELECT workouts.id AS workout_id, user_id, workout_name, exercises.id AS exercise_id, exercise_name, image_url, weight, sets, reps, notes, post_date FROM workouts LEFT JOIN exercises ON workouts.id = exercises.workout_id WHERE workout_id = $1"
    sql_params = [workout_id]
  elsif exercise_id
    query = "SELECT workouts.id AS workout_id, user_id, workout_name, exercises.id AS exercise_id, exercise_name, image_url, weight, sets, reps, notes, post_date FROM workouts 
      LEFT JOIN exercises ON workouts.id = exercises.workout_id WHERE workout_id = $1 AND exercise_id = $2"
    sql_params = [workout_id, exercise_id]
  end

  run_sql(query, sql_params)
end

def new_exercise(workout_id, exercise_name, image_url, weight, reps, sets, notes)
  query = "INSERT INTO exercises(workout_id, name, image_url, weight, reps, sets, notes) VALUES($1, $2, $3, $4, $5, $6, $7)"
  sql_params = [workout_id, exercise_name, image_url, weight, reps, sets, notes]
  # sql_columns = ['workout_id', 'name', 'image_url', 'weight', 'reps', 'sets', 'notes']
  # sql_prepared_statements = ['$1', '$2', '$3', '$4', '$5', '$6', '$7']

  # exclude_empty(sql_params, sql_columns, sql_prepared_statements)
  # query = "INSERT INTO exercises(#{new_sql_columns}) VALUES(#{new_sql_prepared_statements})"

    run_sql(query, sql_params)
  # run_sql(query, new_sql_params)

end

def update_exercise(name, image, weight, reps, sets, notes, exercise_id)
  query = "UPDATE exercises SET exercise_name=$1, image_url=$2, weight=$3, reps=$4, sets=$5, notes=$6 WHERE id=$7"
  params = [name, image, weight, reps, sets, notes, exercise_id]
  exercise = select_user_exercises(exercise_id)

  keys_arr = ["exercise_name", "image_url", "weight", "reps", "sets", "notes", "exercise_id"]

  sql_params = params.map do |param|
      if param.empty?
        empty_index = params.index(param)
        param = exercise[0][keys_arr[empty_index]]
      else
        param = param
      end
    end

  run_sql(query, sql_params)
end

def delete_record_with_id(table, id)
  query = "DELETE FROM #{table} WHERE id = $1"
  sql_params = [id]
  run_sql(query, sql_params)
end

# def exclude_empty(array)

#   new_array = array.select{ |e| e if e.empty? == false}
#   return new_array
# end

# def exclude_empty(params_array, columns_array, prepared_statements_array)

#   params_array.each do |element|
#     if element.empty?
#       empty_index = params_array.index(element)

#       params_array.slice!(empty_index)
#       columns_array.slice!(empty_index)
#       prepared_statements_array.slice!((empty_index+1))

#     end
#   end

#   return params_array
#   return columns_array
#   return prepared_statements_array

# end
# params_array = ['a','b','','d','e','f']
# columns_array = ['a','b','c','d','e','f']
# prepared_statements_array = ['a','b','c','d','e','f']
# exclude_empty(params_array, columns_array, prepared_statements_array)


def remove_empty_entries(string)
  array = string.split(',') # ["name = $1", " image_url = $2", " weight = $3", " reps = $4", " sets = $5", " notes= $6"] 
  new_array = []

  array.each do |element|
    new_array.push(element.split("="))
  end
  # new_array = [["name", "$1"], ["image_url", "$2"], 
  #               [" weight", "$3"], ["reps", "$4"], ["sets", ""], ["notes", "$6"]] 


  new_array.each do |child_array|
    if child_array.length < 2
      new_array.slice!(new_array.index(child_array))
    end
  end

  column_value_pairs_array = new_array.map {|child| child.join("=")}

  sql_column_value_pairs = column_value_pairs_array.join(",")

  return sql_column_value_pairs
end

# string = "name=$1, image_url=$2, weight=$3, reps=$4, sets=, notes=$6" 
# function(string)


#   new_array = [["name", "$1"], ["image_url", "$2"], ["weight", "$3"], ["reps", "$4"], ["sets", "$5"], ["notes", "$6"]] 


# get '/workouts/:workout_id/:exercise_id' do |workout_id, exercise_id|
#   results = select_user_exercises(exercise_id)

#   erb :'workouts/exercises/show', locals: {individual_exercise: results[0]}
# end