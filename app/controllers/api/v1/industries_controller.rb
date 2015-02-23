module Api
  module V1
    class IndustriesController < ApplicationController
      respond_to :json

      def index
        render json: find_industries, only: [:id, :name]
      end

      private

      def find_industries
        return Industry.all if params[:source].nil? && params[:topic].nil?

        if params[:source] && params[:topic] && params[:log_failed]

        end

        source = Source.find_by(name: params[:source]) if params[:source].present?

        return Industry.none if params[:source].present? && source.nil?

        filters = {}
        filters[:source_id] = source.id if source.present?
        filters[:name] = params[:topic] if params[:topic].present?
        Industry.joins(sectors: :topics).where(topics: filters)
      end
    end
  end
end
