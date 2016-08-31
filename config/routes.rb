Rails.application.routes.draw do
  resources :somethings
  resources :actions
  root 'something#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
