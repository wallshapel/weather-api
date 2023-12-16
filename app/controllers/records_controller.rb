class RecordsController < ApplicationController

	def index
    	records = Record.includes(:city).all
    	render json: records, include: [:city]
  	end

  	def store
	    record = Record.new(record_params)
	    if record.save
	      render json: record, status: :created
	    else
	      render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
	    end
	end

	def show
	    records = Record.where(city_id: params[:id])
	    render json: records, include: [:city]
	end

	private

	def record_params
	    params.require(:record).permit(:city_id, :humidity)
	end
	
end