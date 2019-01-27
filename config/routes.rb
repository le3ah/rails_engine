Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :customers do
        get "/find", to: 'search#show'
        get "/find_all", to: 'search#index'
        get "/random", to: 'random#show'
        get "/:id/favorite_merchant", to: 'favorite_merchant#show'
      end
      namespace :merchants do
        get "/find", to: 'search#show'
        get "/find_all", to: 'search#index'
        get "/random", to: 'random#show'
        get "/most_revenue", to: 'most_revenue#index'
        get "/most_items", to: 'most_items#index'
        get "/revenue", to: 'revenue_date#show'
        get "/:id/revenue", to: 'single_revenue#show'
        get "/:id/favorite_customer", to: 'customer#show'
        get "/:id/items", to: 'items#index'
        get "/:id/invoices", to: 'invoices#index'
      end
      namespace :items do
        get "/most_revenue", to: 'most_revenue#index'
        get "most_items", to: 'most_items#index'
        get "/:id/best_day", to: 'best_day#show'
      end
      namespace :invoices do
        get "/:id/transactions", to: 'transactions#index'
        get "/:id/invoice_items", to: 'invoice_items#index'
        get "/:id/items", to: 'items#index'
        get "/:id/customer", to: 'customer#show'
        get "/:id/merchant", to: 'merchant#show'
      end
      resources :customers, only: [:index, :show]
      resources :merchants, only: [:index, :show]
      resources :items, only: [:index]
      resources :invoices, only: [:index]
      resources :invoice_items, only: [:index]
      resources :transactions, only: [:index]
    end
  end
end
