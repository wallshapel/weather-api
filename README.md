# README

Enunciado del problema:

Crear un API en Rails, React y PostgreSQL que permita observar en un mapa las humedades en tiempo real de las ciudades de Miami, Orlando y New York. Adicionalmente se debe generar un histórico de las humedades de dichas ciudades para su consulta.


1) Crear el proyecto API con el motor de base de datos PostgreSQL

	`rails new weather -d postgresql --api --skip-sprockets --skip-importmap --skip-turbo-link --skip-stimulus`


2) Establecer el puerto por donde se lanzará la app

	Ir al archivo /config/puma.rb y modificar la línea:
		`port ENV.fetch("PORT") { 8000 }`

	
3) Crear la base de datos basado en el nombre del proyecto

	`rails db:create`
	
	* La base de datos de desarrollo se llamará `weather_development` y la de testeo `weather_test`


4) Creamos el modelo `City` y añadimos un campo de tipo string llamado `name`

	`rails g model City name:string`

4.1) Indicamos que el campo `name` no esté vacío
	
	`validates :name, presence: true`


5) Generamos el modelo `Record` con un campo llamado `humidity` y con una llave fornaea `city_id`

	`rails g model Record city:references humidity:integer`


6) Definimos en el modelo `city` que el campo `humidity` no esté vacío

	`validates :humidity, presence: true`


7) Ejecutamos migraciones

	`rails db:migrate`


8) Creamos los seeds para la tabla `cities`
	
	`City.create(name: 'Miami')
	City.create(name: 'New York')
	City.create(name: 'Orlando')`

8.1) Ejecutamos los seeds

	`rails db:seed`


9) Generamos un controlador para `city` y un método `index`

	`rails g controller Cities index --skip-template-engine`

	`def index
        render json: City.all
    end`


10) Generamos un controlador para `record`

	`rails g controller Records --skip-template-engine`

	`def index
    	records = Record.includes(:city).all
    	render json: records, include: [:city]
  	end`

  	`def store
	    record = Record.new(record_params)
	    if record.save
	      render json: record, status: :created
	    else
	      render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
	    end
	end`

	`def show
	    records = Record.where(city_id: params[:id])
	    render json: records, include: [:city]
	end`

	`private`

	`def record_params
	    params.require(:record).permit(:city_id, :humidity)
	end`


11) Definimos las rutas de los controladores

	`scope '/api' do

        get '/', to: 'cities#index'

        get '/record', to: 'records#index'
        post '/record', to: 'records#store'

    end`


12) Solucionar el problema de CROSS ORIGIN

	* Añadir al Gemfile la gema `rack-cors` con `gem rack-cors`

	* Ejecutar `bundle install`

	* Crear un archivo llamado `cors.rb` en el directorio `config/initializers` y agregar el siguiente código:

		`Rails.application.config.middleware.insert_before 0, Rack::Cors do
			allow do
		    	origins '*' # Se puede cambiar '*' por el dominio específico del frontend
		    	resource '*', headers: :any, methods: [:get, :post]
		  	end
		end`

	* Guardar los cambios y reiniciar el servidor de Rails