Cloudiversity::Application.routes.draw do
    devise_for :users

    namespace :admin do
        resources :users
        resources :school_classes do
            get 'add' => 'school_classes#add', as: 'add'
            post 'add' => 'school_classes#add'
            delete ':user_id' => 'school_classes#remove', as: 'remove'
        end
    end

    get 'admin' => 'static#admin', as: :admin

    root 'static#home'
end
