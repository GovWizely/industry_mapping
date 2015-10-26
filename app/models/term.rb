class Term < ActiveRecord::Base
  has_and_belongs_to_many(:children,
                          class_name:              'Term',
                          join_table:              'children',
                          foreign_key:             'term_a_id',
                          association_foreign_key: 'term_b_id')

  has_and_belongs_to_many(:parents,
                          class_name:              'Term',
                          join_table:              'parents',
                          foreign_key:             'term_b_id',
                          association_foreign_key: 'term_a_id')

  has_and_belongs_to_many(:mapped_terms, join_table: 'terms_joined_mapped_terms')

  has_and_belongs_to_many(:taxonomies, join_table: 'terms_joined_taxonomies')

  validates :protege_id, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end
