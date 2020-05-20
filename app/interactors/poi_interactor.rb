# frozen_string_literal: true

require 'singleton'

class PoiInteractor
  include Singleton

  def get_all
    PointOfInterest.order('created_at DESC')
  end

  def get_poi_by_id(id)
    PointOfInterest.find(id)
  end

  def create_new_poi(poi_params)
    poi = PointOfInterest.new(poi_params)

    [poi.save, poi]
  end

  def delete_poi(id)
    poi = PointOfInterest.find(id)
    poi.destroy

    poi
  end

  def update_poi(id, poi_params)
    poi = PointOfInterest.find(id)

    [poi.update(poi_params), poi]
  end

  def get_pois_inside_radius(x, y, radius)
    all_pois = PointOfInterest.all

    pois_inside_radius = []

    all_pois.each do |poi|
      euclidian_distance = Math.sqrt((x - poi.x)**2 + (y - poi.y)**2)
      pois_inside_radius << poi if euclidian_distance <= radius
    end
    pois_inside_radius
  end
end
