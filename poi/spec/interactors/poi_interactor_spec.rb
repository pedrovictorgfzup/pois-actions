require 'rails_helper'


RSpec.describe PoiInteractor do

    it "should return all pois" do

        result = PoiInteractor.instance.get_all 

        expect(result.size).to be == 3
    end

    it "should find a poi by the id" do
        result = PoiInteractor.instance.get_poi_by_id(1)

        expect(result).to_not be_nil
    end

    it "should create a new poi" do
        result_succes, result = PoiInteractor.instance.create_new_poi({name:"poi para ser deletada", x:10, y:10})

        expect(result_succes).to eq(true)
    end

    it "should update an existing poi" do
        result_succes, result = PoiInteractor.instance.update_poi(1, {name:"poi alterada", x:10, y:10})

        expect(result_succes).to eq(true)
    end

    it "should delete an existing poi" do
        before_deletion = PoiInteractor.instance.get_all.size
        
        PoiInteractor.instance.delete_poi(1)

        after_deletion = PoiInteractor.instance.get_all.size
        
        expect(after_deletion).to be < before_deletion
    end

    it "should return the other poi's that are inside the radius from any given point" do
        all_pois = PoiInteractor.instance.get_all

        result = PoiInteractor.instance.get_pois_inside_radius(10,10,20)

        expect(result).to_not be_nil
        expect(result.size).to be == 1
    end
end 