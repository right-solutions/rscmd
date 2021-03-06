Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'website/home#index'

  # -------------
	# Website Pages
	# -------------

	scope module: 'website' do
		get 'about_us' => "home#about_us", as: :about_us

    get 'gallery' => "gallery#index", as: :gallery

    get 'contact_us' => "contact_us#index"
    post 'contact_us' => "contact_us#create"

    post 'subscriptions' => "home#subscribe", as: :subscribe
	end

  # -----------
  # LOGIN 
  # -----------

  # Sign In URLs for users
  get  '/sign_in',                    to: "sessions#sign_in",               as: :sign_in
  post '/create_session',             to: "sessions#create_session",        as: :create_session
  get  '/forgot_password_form',       to: "sessions#forgot_password_form",  as: :forgot_password_form
  post '/forgot_password',            to: "sessions#forgot_password",       as: :forgot_password
  get  '/reset_password_form/:id',    to: "sessions#reset_password_form",   as: :reset_password_form
  put  '/reset_password_update/:id',  to: "sessions#reset_password_update", as: :reset_password_update
  
  # Logout Url
  delete  '/sign_out' ,               to: "sessions#sign_out",  as:  :sign_out


	namespace :admin do

    get   '/dashboard',         to: "dashboard#index",  as:   :dashboard

    resources :users do
      member do
        put :masquerade, as: :masquerade
        put :update_status, as:  :update_status
        put :make_admin, as:  :make_admin
        put :make_super_admin, as:  :make_super_admin
        put :remove_admin, as:  :remove_admin
        put :remove_super_admin, as:  :remove_super_admin
      end
    end

    resources :enquiries do
      member do
        put :update_status, as:  :update_status
      end
    end

    resources :testimonials do
      member do
        put :update_status, as:  :update_status
      end
    end

    resources :subscriptions
    
    resources :images do
      member do
        put :crop
      end
    end
  end
  
end
