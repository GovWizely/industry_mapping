class Taxonomy < ActiveRecord::Base
  has_and_belongs_to_many(:terms, join_table: 'terms_joined_taxonomies')
  validates :name, presence: true, uniqueness: true
end
