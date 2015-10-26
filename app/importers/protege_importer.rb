require 'open-uri'
require 'zip'

class ProtegeImporter
  # This is the STAGING protege URL, will need to switch this to Production
  ZIP_URL = 'http://52.4.82.207:8080/webprotege/download?ontology=0aa09276-58a6-4350-a0bb-60eb2ab4be00'

  def initialize(resource = ZIP_URL)
    @resource = resource

    @industries_root = {}
    @world_regions_root = {}
    @countries_root = {}
    @trade_regions_root = {}
    @topics_root = {}

    @terms = []
    @processed_terms = []
  end

  def import(taxonomies)
    @importable_taxonomies = taxonomies

    xml = extract_xml_from_zip
    parse_terms_from_xml(xml)

    @root_terms = [@industries_root, @world_regions_root, @countries_root, @trade_regions_root, @topics_root]
    @root_terms.reject! { |r| r == {} }

    extract_actual_taxonomy_terms
    find_parent_names
    find_child_names

    update_or_add_taxonomies
    update_or_add_terms
    set_term_relationships
    delete_old_terms
  end

  def extract_actual_taxonomy_terms
    @terms.each do |term|
      taxonomies = get_taxonomies_of_term(term)
      if taxonomies.include?(@industries_root)
        term[:taxonomies] << @industries_root[:name]
        @processed_terms.push(term)
      end
      if taxonomies.include?(@world_regions_root)
        term[:taxonomies] << @world_regions_root[:name]
        @processed_terms.push(term)
      end
      if taxonomies.include?(@countries_root)
        term[:taxonomies] << @countries_root[:name]
        @processed_terms.push(term)
      end
      if taxonomies.include?(@trade_regions_root)
        term[:taxonomies] << @trade_regions_root[:name]
        @processed_terms.push(term)
      end
      if taxonomies.include?(@topics_root)
        term[:taxonomies] << @topics_root[:name]
        @processed_terms.push(term)
      end
    end
  end

  def get_taxonomies_of_term(term)
    taxonomies = []
    temp_ids = term[:parent_ids].dup
    ##  Trace through all parents of a term until we hit the roots for all branches:
    while temp_ids.size > 0
      temp_ids.delete_if do |parent_id|
        if @root_terms.map { |root| root[:protege_id] }.include? parent_id
          taxonomies << @root_terms.find { |root| root[:protege_id] == parent_id }
          true
        elsif parent_id == 'http://www.w3.org/2002/07/owl#Thing'
          true
        end
      end

      new_parents = []
      @terms.each do |t|
        if temp_ids.include?(t[:protege_id])
          temp_ids.delete(t[:protege_id])
          new_parents.concat t[:parent_ids]
        end
      end
      temp_ids.concat new_parents
    end

    taxonomies
  end

  def extract_xml_from_zip
    open('temp.zip', 'wb') { |file| file << open(@resource).read }

    content = ''
    Zip::File.open('temp.zip') do |zip_file|
      zip_file.each do |entry|
        content = entry.get_input_stream.read if entry.name.end_with?('.owl')
      end
    end

    File.delete('temp.zip')
    Nokogiri::XML(content)
  end

  def parse_terms_from_xml(xml)
    classes = xml.xpath('//owl:Class')
    classes.each do |owl_class|
      parents = owl_class.xpath('./rdfs:subClassOf').select { |parent| !parent.attr('rdf:resource').nil? }
      parent_ids = parents.map { |parent| parent.attr('rdf:resource') }
      term_hash = build_term_hash(owl_class, parent_ids)

      name =  owl_class.xpath('./rdfs:label').text
      if name == 'Industries' && @importable_taxonomies.include?('Industries')
        @industries_root = term_hash
      elsif name == 'World Regions' && @importable_taxonomies.include?('World Regions')
        @world_regions_root = term_hash
      elsif name == 'Countries' && @importable_taxonomies.include?('Countries')
        @countries_root = term_hash
      elsif name == 'Trade Regions' && @importable_taxonomies.include?('Trade Regions')
        @trade_regions_root = term_hash
      elsif name == 'Topics' && @importable_taxonomies.include?('Topics')
        @topics_root = term_hash
      end
      @terms << term_hash
    end
  end

  def build_term_hash(owl_class, parent_ids)
    { name:       owl_class.xpath('./rdfs:label').text,
      protege_id: owl_class.attr('rdf:about'),
      parent_ids: parent_ids,
      taxonomies: [],
      parents:    [],
      children:   [],
    }
  end

  def find_parent_names
    @processed_terms.each do |term|
      parents = @terms.select { |t| term[:parent_ids].include? t[:protege_id] }
      term[:parents] = parents.map { |t| t[:name] }
    end
  end

  def find_child_names
    @processed_terms.each do |term|
      parent_names = term[:parents]
      parent_terms = @processed_terms.select { |t| parent_names.include?(t[:name]) }
      parent_terms.each { |t| t[:children] << term[:name] }
    end
  end

  # Active Record methods, might make sense to move this code to models?
  def update_or_add_terms
    @processed_terms.each do |term|
      if Term.exists?(protege_id: term[:protege_id])
        term = Term.find_by(protege_id: term[:protege_id])
        term.update(name: term[:name])
      else
        term = Term.create(protege_id: term[:protege_id], name: term[:name])
      end
    end
  end

  def update_or_add_taxonomies
    @root_terms.each do |term|
      if Taxonomy.exists?(protege_id: term[:protege_id])
        taxonomy = Taxonomy.find_by(protege_id: term[:protege_id])
        taxonomy.update(name: term[:name])
      else
        taxonomy = Taxonomy.create(protege_id: term[:protege_id], name: term[:name])
      end
    end
  end

  def set_term_relationships
    @processed_terms.each do |term|
      saved_term = Term.find_by(protege_id: term[:protege_id])
      parent_terms = term[:parents].map { |parent| Term.find_by(name: parent) }.compact
      child_terms = term[:children].map { |child| Term.find_by(name: child) }.compact
      taxonomies = term[:taxonomies].map { |taxonomy| Taxonomy.find_by(name: taxonomy) }.compact

      saved_term.parents = parent_terms unless parent_terms.empty?
      saved_term.children = child_terms unless child_terms.empty?
      saved_term.taxonomies = taxonomies unless taxonomies.empty?
    end
  end

  def delete_old_terms
    Term.all.each do |db_term|
      if @processed_terms.find { |protege_term| protege_term[:protege_id] == db_term.protege_id }.nil?
        db_term.destroy
      end
    end

    Taxonomy.all.each do |db_taxonomy|
      if @root_terms.find { |protege_taxonomy| protege_taxonomy[:protege_id] == db_taxonomy.protege_id }.nil?
        db_taxonomy.destroy
      end
    end
  end
end
