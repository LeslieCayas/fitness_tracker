get '/' do
  redirect '/welcome'
  erb :index
end

get '/workouts' do

  erb :show
end

get '/workouts/:id' do |id|

  erb :show_selected
end
