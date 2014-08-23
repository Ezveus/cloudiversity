Cloudiversity::Application.routes.draw do
    devise_for :users, controllers: { sessions: 'cloudiversity/sessions' }

    get 'version' => 'static#version'

    get 'user/:id' => 'users#show', as: 'user', id: /[a-z][\w\.-]+/i
    get 'users/current' => 'users#current'

    namespace :admin do
        resources :users, id: /[a-z][\w\.-]+/i do
            post 'reset_password' => 'users#reset_password', as: 'reset_password'
            post 'unlock' => 'users#unlock', as: 'unlock'

            get 'promote/admin' => 'admins#new', as: 'promote_admin'
            get 'demote/admin' => 'admins#destroy', as: 'demote_admin'
            get 'promote/teacher' => 'teachers#new', as: 'promote_teacher'
            get 'demote/teacher' => 'teachers#destroy', as: 'demote_teacher'
            get 'promote/student' => 'students#new', as: 'promote_student'
            get 'demote/student' => 'students#destroy', as: 'demote_student'

            collection do
                get 'search' => 'users#search', as: 'search'
                post 'search' => 'users#search'
            end

            get 'delete' => 'users#destroy', as: 'destroy'
        end

        resources :admins, only: [ :create, :destroy ]
        resources :teachers, only: [ :index, :create, :destroy ] do
            get 'assign' => 'teachers#assign', as: 'assign'
            post 'assign' => 'teachers#assign'

            get 'transfer' => 'teachers#transfer', as: 'transfer'
            post 'transfer' => 'teachers#transfer'

            get 'unassign' => 'teachers#unassign', as: 'unassign'
            delete 'unassign' => 'teachers#unassign'
        end
        resources :students, only: [ :create, :destroy, :edit, :update ]

        resources :school_classes, id: Handleable::ROUTE_FORMAT do
            get 'add' => 'school_classes#add', as: 'add'
            post 'add' => 'school_classes#add'
            delete ':student_id' => 'school_classes#remove', as: 'remove'
        end
        resources :disciplines, id: Handleable::ROUTE_FORMAT
        resources :periods, id: Handleable::ROUTE_FORMAT do
            member do
                get :destroy_confirmation
                get :set_current
                post :set_current
            end
        end
    end

    get 'admin' => 'static#admin', as: :admin

    root 'static#home'
end
