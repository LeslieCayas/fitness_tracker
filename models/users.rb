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


def is_valid_email(email) 
  at_count = email.count "@"
  dot_count = email.count "."
  email_array = email.split('@')
  error_message = "Invalid email"
  success_message = "Success!"
  if at_count != 1 
    return error_message
  end

  if dot_count == 0 
    return error_message
  end

  if email_array.length == 1 
    return error_message
  end

  if email_array.last.to_s.count(".") == 0 
    return error_message
  end

  email_array.each do |email_split|
    if email_split.include?(".") 
      if email_split.end_with?(".") 
        return error_message
      elsif email_split.start_with?(".") 
        return error_message
      end
    elsif email_split.empty? 
      return error_message
    end
  end
  return success_message
end