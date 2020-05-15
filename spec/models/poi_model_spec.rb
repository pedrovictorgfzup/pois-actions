require 'rails_helper'

RSpec.describe PointOfInterest do
it "is valid with valid attributes" do poi = PointOfInterest.new
        poi.x = 2
        poi.y = 3
        poi.name = "Valid point of interest name"

        expect(poi).to be_valid
    end

it "is invalid for negative coordinates" do
        poi = PointOfInterest.new
        poi.name = "Valid point of interest name"
        poi.x = -2
        poi.y = -3
        expect(poi).to be_invalid
    end

it "is invalid for names shorter than 3 characters" do
        poi = PointOfInterest.new
        poi.name = "V"
        poi.x = 2
        poi.y = 3
        expect(poi).to be_invalid
    end
end