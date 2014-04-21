Cloudiversity::Application.routes.draw do
    devise_for :users, controllers: { sessions: 'cloudiversity/sessions' }

    namespace :admin do
        resources :users
        resources :school_classes do
            get 'add' => 'school_classes#add', as: 'add'
            post 'add' => 'school_classes#add'
            delete ':student_id' => 'school_classes#remove', as: 'remove'
        end
        resources :teachers do
            get 'add_school_class' => 'teachers#add_school_class', as: 'add_school_class'
            post 'add_school_class' => 'teachers#add_school_class'
            get 'rem_school_class' => 'teachers#rem_school_class', as: 'rem_school_class'
            post 'rem_school_class' => 'teachers#rem_school_class'
        end
        resources :disciplines
        resources :students
    end

    get 'admin' => 'static#admin', as: :admin

    root 'static#home'
end
