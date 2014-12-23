class SearchController < ApplicationController
  def lookup_by_topic
    if !["industries", "sectors"].index( params[:model] )
      head :not_found
      return
    end

    topics = Topic.where(nil)
    if params[:source]
      src = Source.find_by( name: params[:source] )
      topics = src ? topics.where( source_id: src.id ) : Topic.none
    end
    topics = topics.where( name: params[:topic] ) if params[:topic].present?
    @objects = topics.map { |t| t.send(params[:model].singularize.to_sym) }.compact
    Topic.create( name: params[:topic], source: src ) if src && params[:topic].present? && topics.length == 0

    render :lookup_by_topic
  end
end