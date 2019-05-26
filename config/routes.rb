Rails.application.routes.draw do

  resources :trackers

  get 'get_devices', to: 'trackers#fetch_devices'
  get 'single_device', to: 'trackers#fetch_single_device'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
