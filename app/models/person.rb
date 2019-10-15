class Person < ApplicationRecord

    DEFAULT_GENDERS = %w(m f o).freeze

    has_many :locations
    has_many :affiliations, autosave: true

    validates :first_name, :last_name, :gender, presence: true
    validates :first_name, format: {with: /\A[a-zA-Z]+\z/}
    validates :gender, inclusion: {in: DEFAULT_GENDERS}
    validates :first_name, uniqueness: {scope: :last_name}
    validates :affiliations, presence: true

    normalize_attribute :first_name, :last_name, :with => [:squish, :titleize]
    before_save :titleize_names
    before_validation :format_gender, on: :create

    def full_name
      [self.first_name, self.last_name].join(" ")
    end

    def get_gender
      gender
    end

    scope :query, -> (query) {
      where('first_name = ? or last_name = ?', query, query)
    }


  private
    def titleize_names
      self.first_name.titleize
      self.last_name.titleize
    end

    def format_gender
      unless gender.blank? || DEFAULT_GENDERS.include?(gender.downcase)
        self.gender = gender_map.fetch(gender.downcase, nil)
      end
    end

    def gender_map
      {'male': 'm', 'female': 'f', 'other': 'o'}.with_indifferent_access
    end

end
