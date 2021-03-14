Rottenpotatoes::Application.routes.draw do
  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')
  
  match '/movies/director/:id', to: 'movies#director', via: [:get], as: 'director'
  resources :movies

end
