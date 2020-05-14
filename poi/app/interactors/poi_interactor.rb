require 'singleton'

class PoiInteractor
    include Singleton

    def get_all
        return PointOfInterest.order('created_at DESC');
    end

    def get_poi_by_id(id)
        return PointOfInterest.find(id)
    end

    def create_new_poi(poi_params)
        poi = PointOfInterest.new(poi_params)

        return poi.save, poi
    end

    def delete_poi(id)
        poi = PointOfInterest.find(id)
        poi.destroy
        
        return poi
    end

    def update_poi(id, poi_params)
        poi = PointOfInterest.find(id)

        return poi.update(poi_params), poi         
    end

    def get_pois_inside_radius(x, y, radius)
        all_pois = PointOfInterest.all

        pois_inside_radius = []

        all_pois.each do |poi|
            euclidian_distance = Math.sqrt( (x-poi.x)**2 + (y-poi.y)**2 )
            if euclidian_distance <= radius
                pois_inside_radius << poi
            end
        end
        return pois_inside_radius
    end
end