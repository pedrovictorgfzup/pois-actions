# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :poi

  get 'nearby_pois', to: 'poi#get_pois_inside_radius', constraints: { x: /\d*/, y: /\d*/, radius: /\d*/ }
end
