require 'bcrypt'

def create_user( email, username, password)
  password_digest = BCrypt::Password.create(password)

  query = "INSERT INTO users(email, username, password) VALUES($1, $2, $3)"

  sql_params = [email, username, password_digest]

  run_sql(query, sql_params)
end