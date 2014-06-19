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
        end

        resources :admins, only: [ :create, :destroy ]
        resources :teachers, only: [ :index, :create, :destroy ] do
            get 'assign' => 'teachers#assign', as: 'assign'
            post 'assign' => 'teachers#assign'
        end
        resources :students, only: [ :create, :destroy ]

        resources :school_classes do
            get 'add' => 'school_classes#add', as: 'add'
            post 'add' => 'school_classes#add'
            delete ':student_id' => 'school_classes#remove', as: 'remove'
        end
        resources :disciplines
    end

    get 'admin' => 'static#admin', as: :admin

    root 'static#home'
end
