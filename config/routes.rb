Cloudiversity::Application.routes.draw do
    devise_for :users

    namespace :admin do
        resources :users
    end

    get 'admin' => 'static#admin', as: :admin

    root 'static#home'
end
