class PointOfInterest < ApplicationRecord
    validates :name, presence: true, length: { minimum: 3}
    validates :x, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :y, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
