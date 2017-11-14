module Api
  module V1
    class RestController < ApplicationController
      def index
        keys = %i[start lenght order search]
        filter_opts = keys.each_with_object({}) { |k, res| res[k] = params[k] }
        resources = index_filter(filter_opts)
        render json: {
          records: resources,
          total: resources.count,
          filtered: model.count
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

      def index_filter(_)
        model.all
      end
    end
  end
end
