module Api
  module V1
    class RestController < ApplicationController
      def index
        resources = model.ransack(params[:q]).result.paginate(paginate_opts)
        render json: {
          records: resources,
          total: model.count,
          filtered: resources.count
        }
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end

      def show
        resource = model.find(params[:id])
        respond_with resource
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end

      def create
        resource = model.new(resource_params)
        yield resource if block_given?
        if resource.save
          render json: resource, status: :created
        else
          status = :unprocessable_entity
          render json: json_errors(resource.errors), status: status
        end
      end

      def update
        resource = model.find(params[:id])
        yield resource if block_given?
        if resource.update(resource_params)
          render json: resource, status: :ok
        else
          status = :unprocessable_entity
          render json: json_errors(resource.errors), status: status
        end
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end

      def destroy
        resource = model.find(params[:id])
        yield resource if block_given?
        resource.destroy
        head :no_content
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end

      private

      def model
        controller_name.classify.constantize
      end

      def json_errors(errors)
        { errors: errors.to_hash.merge(full_messages: errors.full_messages) }
      end

      def paginate_opts
        { page: params[:page] || 1, per_page: params[:per_page] || 10 }
      end
    end
  end
end
