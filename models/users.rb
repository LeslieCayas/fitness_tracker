require 'bcrypt'

def create_user( email, username, password)
  password_digest = BCrypt::Password.create(password)

  query = "INSERT INTO users(email, username, password) VALUES($1, $2, $3)"

  sql_params = [email, username, password]

  run_sql(query, sql_params)
end

def find_user_by(sql_column, email_value, id_value)
  query = ""
  sql_params = []

  if sql_column == "email"
    sql_params.push(email_value)
    query = "SELECT * FROM users WHERE email = $1"
  elsif sql_column == "id"
    sql_params.push(id_value)
    query = "SELECT * FROM users WHERE id = $1"
  end

  results = run_sql(query, sql_params)

  if results.to_a.length > 0
    return results[0]
  else
    return nil
  end
end