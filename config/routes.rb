Rails.application.routes.draw do

    scope '/api' do
        # cities
        get '/', to: 'cities#index'
        # records
        get '/record', to: 'records#index'
        post '/record', to: 'records#store'
    end

end