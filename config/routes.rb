Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root 'welcome#index'
  get '/terms' => 'terms#index'
  get '/faq' => 'common_questions#index'
  get '/users' => 'users#index'
  get '/about' => 'about#index'
  get '/projects' => 'projects#index'
  get '/sign-up' => 'registrations#new'
  post '/sign-up' => 'registrations#create'
  get '/sign-out' => 'authentication#destroy'
  get '/sign-in' => 'authentication#new'
  post '/sign-in' => 'authentication#create'

  resources :users

  resources :projects do
    resources :tasks
  end
end
