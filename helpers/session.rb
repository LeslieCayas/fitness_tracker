def is_logged_in?
  if session[:user_id]
    return true
  else
    return false
  end


end

def current_user
  if is_logged_in?
    return find_user_by( "id", nil, session[:user_id] )
  else
    return nil
  end
end

def check_user
  if is_logged_in? == false
    error_message = "You do not have access to this. Please log in."
  else
    error_message = ""
  end
  return error_message
end
