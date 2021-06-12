def is_logged_in?
  if session[:user_id]
    return true
  else
    return false
  end


end


def current_user
  if is_logged_in?
    return find_user_by_id("id", nil, session[:user_id] )
  else
    return nil
  end
end
