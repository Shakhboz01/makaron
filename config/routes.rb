Rails.application.routes.draw do
  resources :sale_product_increasers
  resources :debt_operations
  resources :debt_users
  resources :daily_transaction_reports
  resources :owners_operations
  resources :currency_conversions
  resources :discounts do
    post :verify, on: :member
  end
  resources :product_remaining_inequalities
  resources :transaction_histories
  resources :team_services
  resources :sale_from_services do
    post :default_create, on: :collection
  end
  resources :sales do
    post :default_create, on: :collection
    post :toggle_status, on: :member
    post :generate_pdf, on: :member
  end
  resources :local_services
  resources :sale_from_local_services do
    post :default_create, on: :collection
  end
  resources :delivery_from_counterparties do
    post :default_create, on: :collection
    post :toggle_status, on: :member
  end
  resources :product_sells do
    post :ajax_sell_price_request, on: :collection
  end

  resources :expenditures
  resources :combination_of_local_products
  resources :product_entries do
    get :define_product_destination, on: :collection
  end
  resources :buyers do
    post :toggle_active, on: :member
  end
  resources :providers do
    post :toggle_active, on: :member
  end
  resources :product_categories
  resources :products do
    post :toggle_active, on: :member
    get :calculate_product_remaining, on: :member
  end

  resources :salaries
  resources :teams do
    member do
      post :toggle_active
    end
  end
  resources :currency_rates
  resources :services do
    member do
      post :toggle_active
    end
  end

  resources :participations do
    collection do
      post "accept_new_participation", action: :accept_new_participation, as: :accept_new_participation
    end
  end
  root "pages#main_page"
  get "pages#define_sale_destination", to: "pages#define_sale_destination", as: :define_sale_destination
  get "pages#shortcut", to: "pages#shortcut", as: :shortcut
  get "daily_report", to: "pages#daily_report", as: :daily_report
  get "admin_page", to: "pages#admin_page", as: :admin_page
  devise_for :users, controllers: { sessions: "sessions" }

  resources :users do
    post :update, on: :member
    get :toggle_active_user, on: :member
    get :new_user_form, on: :collection
    post :auto_user_creation, on: :collection
  end
end
