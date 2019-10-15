class Affiliation < ActiveRecord::Base
  belongs_to :person

  normalize_attributes :name, :with => [:squish, :titleize]
end
