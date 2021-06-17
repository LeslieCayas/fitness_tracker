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

def select_joint_table(workout_id)
  query = "SELECT workouts.id AS workout_id, user_id, workout_name, exercises.id AS exercise_id, name, image_url, weight, sets, reps FROM workouts LEFT JOIN exercises ON workouts.id = exercises.workout_id WHERE workout_id = $1"
  sql_params = [workout_id]
  run_sql(query, sql_params)
end

def new_exercise(workout_id, exercise_name, image_url, weight, reps, sets, notes)
  query = "INSERT INTO exercises(workout_id, name, image_url, weight, reps, sets, notes) VALUES($1, $2, $3, $4, $5, $6, $7)"
  sql_params = [workout_id, exercise_name, image_url, weight, reps, sets, notes]
  run_sql(query, sql_params)
end

def update_exercise(name, image, weight, reps, sets, notes, exercise_id)
  query = "UPDATE exercises SET name = $1, image_url = $2, weight = $3, reps = $4, sets = $5, notes= $6 WHERE id = $7"
  sql_params = [name, image, weight, reps, sets, notes, exercise_id]
  run_sql(query, sql_params)
end

def delete_record_with_id(table, id)
  query = "DELETE FROM #{table} WHERE id = $1"
  sql_params = [id]
  run_sql(query, sql_params)
end