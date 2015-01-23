Cloudiversity::Application.routes.draw do
    devise_for :users, controllers: { sessions: 'cloudiversity/sessions' }

    get 'version' => 'static#version'
    get 'locale/:locale' => 'static#locale', as: 'locale'

    # Users are a complicated resource, let's do it manually
    # resources :users, id: /[a-z][\w\.-]+/i
    get '/u/:id' => 'users#show', id: User::ID_FORMAT, as: 'user'

    get  '/users'     => 'users#index', as: 'users'
    get  '/users/new' => 'users#new',   as: 'new_user'
    post '/users'     => 'users#create'

    get    '/u/:id/edit' => 'users#edit',   id: User::ID_FORMAT, as: 'edit_user'
    patch  '/u/:id'      => 'users#update', id: User::ID_FORMAT
    put    '/u/:id'      => 'users#update', id: User::ID_FORMAT
    delete '/u/:id'      => 'users#delete', id: User::ID_FORMAT

    get    '/school_class/:id/students' => 'admin/school_classes#list_students'

    # TODO: Tear this down.
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
            # The main page for transfers
            get 'add'                           => 'school_classes#add',     as: 'add_wizard'

            # Add new students or take them from another class
            get 'add/new'                       => 'school_classes#add_new', as: 'add_new'
            get 'transfer/:old_school_class_id' => 'school_classes#transfer', old_school_class_id: Handleable::ROUTE_FORMAT, as: 'transfer'

            # Proceed to changes
            post 'add'                          => 'school_classes#add_proceed'
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
    get 'home' => 'static#home', as: :home

    root 'static#home'
end
