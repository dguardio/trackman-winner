Rails.application.routes.draw do

  resources :trips
  resources :trackers do
  	post '', to: 'trackers#update'
    get 'metrics', to: 'trackers#metrics'
  end
  get 'tracker-mgt', to: 'trackers#trackers_index'
  # post 'locator', to: 'trackers#update'

  get 'get_devices', to: 'trackers#fetch_devices'
  get 'single_device', to: 'trackers#fetch_single_device'
  root 'landings#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
