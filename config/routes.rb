Rails.application.routes.draw do
  resources :somethings, defaults:{format: :json} do

  end
  resources :actions
  root 'somethings#new'
  get 'ec2start', to: 'apis#ec2start'
  get 'ec2stop', to: 'apis#ec2stop'
  get 'createrds', to: 'apis#rdsstart'
  get 'deleterds', to: 'apis#rdsstop'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
