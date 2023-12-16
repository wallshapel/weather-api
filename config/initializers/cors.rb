Rails.application.config.middleware.insert_before 0, Rack::Cors do

	allow do
    	origins '*' # Se puede cambiar '*' por el dominio específico del frontend
    	resource '*', headers: :any, methods: [:get, :post]
  	end

end