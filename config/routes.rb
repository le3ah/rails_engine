Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :customers do
        get "/find", to: 'search#show'
        get "/find_all", to: 'search#index'
        get "/random", to: 'random#show'
        get "/:id/favorite_merchant", to: 'favorite_merchant#show'
        get "/:id/invoices", to: 'invoices#index'
        get "/:id/transactions", to: 'transactions#index'
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
        get "/:id/invoice_items", to: 'invoice_items#index'
        get "/:id/merchant", to: 'merchant#show'
        get "/find", to: 'search#show'
        get "/find_all", to: 'search#index'
      end
      namespace :invoices do
        get "/:id/transactions", to: 'transactions#index'
        get "/:id/invoice_items", to: 'invoice_items#index'
        get "/:id/items", to: 'items#index'
        get "/:id/customer", to: 'customer#show'
        get "/:id/merchant", to: 'merchant#show'
        get "/find", to: 'search#show'
        get "/find_all", to: 'search#index'
      end
      namespace :invoice_items do
        get "/:id/invoice", to: 'invoice#show'
        get "/:id/item", to: 'item#show'
        get "/find", to: 'search#show'
        get "/find_all", to: 'search#index'
      end
      namespace :transactions do
        get "/:id/invoice", to: 'invoice#show'
        get "/find", to: 'search#show'
        get "/find_all", to: 'search#index'
      end
      resources :customers, only: [:index, :show]
      resources :merchants, only: [:index, :show]
      resources :items, only: [:index]
      resources :invoices, only: [:index, :show]
      resources :invoice_items, only: [:index, :show]
      resources :transactions, only: [:index]
    end
  end
end
