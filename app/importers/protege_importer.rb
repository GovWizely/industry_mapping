class ProtegeImporter
  def initialize(resource = nil)
    @parser = resource.nil? ? TaxonomyParser.new(ENV["PROTEGE_URL"]) : TaxonomyParser.new(resource)
  end

  def import
    @parser.parse

    Taxonomy.update_taxonomies_from_protege(@parser.concept_groups)
    Term.update_terms_from_protege(@parser.concepts)
  end
end
