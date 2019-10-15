class Location < ApplicationRecord
  # belongs_to :locationable, polymorphic: true
  belongs_to :person
  normalize_attribute :name, :with => [:squish, :titleize]
end
