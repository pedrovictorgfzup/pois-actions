class PoiController < ApplicationController
    def index
        result = interactor.get_all
        render json: {status: "SUCCESS", message:"Points of interest loaded", data:result},status: :ok
    end

    def show
        result = interactor.get_poi_by_id(params[:id])
        render json: {status: 'SUCCESS', message:'Loaded point of interest', data:result},status: :ok
    end

    def create
        success, poi = interactor.create_new_poi(poi_params)

		if success
			render json: {status: 'SUCCESS', message:'Saved point of interest', data:poi},status: :ok
		else
			render json: {status: 'ERROR', message:'Point of interest not saved', data:poi.errors},status: :unprocessable_entity
        end
    end

    def get_pois_inside_radius
        result = interactor.get_pois_inside_radius(params[:x], params[:y], params[:radius])
        render json: {data:result}
    end

    def destroy
        result = interactor.delete_poi(params[:id])
        render json: {status: 'SUCCESS', message:'Deleted point of interest', data:result},status: :ok
    end

    def update
        success, poi = interactor.update_poi(params[:id], poi_params)
        
        if success
            render json: {status: 'SUCCESS', message:'Updated point of interest', data:poi},status: :ok
        else
            render json: {status: 'ERROR', message:'Point of interest not update', data:poi.errors},status: :unprocessable_entity
        end
    end

    def interactor
        PoiInteractor.instance
    end
	
	private
        def poi_params
            params.permit(:name, :x, :y)
        end
    
end