module Api
  module V1
    class RestController < ApplicationController
      def index
        resources = model.all
        render json: {
          data: resources,
          recordsTotal: resources.count,
          recordsFiltered: resources.count
        }
      end

      def show
        resource = model.find(params[:id])
        respond_with resource
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end

      def create
        resource = model.new(resource_params)
        if resource.save
          render json: resource, status: :created
        else
          status = :unprocessable_entity
          render json: { errors: resource.errors }, status: status
        end
      end

      def update
        resource = model.find(params[:id])
        if resource.update(resource_params)
          render json: resource, status: :ok
        else
          status = :unprocessable_entity
          render json: { errors: resource.errors }, status: status
        end
      end

      def destroy
        resource = model.find(params[:id])
        resource.destroy
        head :no_content
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end

      private

      def model
        controller_name.classify.constantize
      end
    end
  end
end
