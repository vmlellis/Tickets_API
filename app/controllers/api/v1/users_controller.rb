module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_admin!

      def index
        users = User.all
        render json: {
          data: users, recordsTotal: users.count, recordsFiltered: users.count
        }
      end

      def show
        user = User.find(params[:id])
        respond_with user
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end

      def create
        user = User.new(user_params)
        if user.save
          render json: user, status: :created
        else
          render json: { errors: user.errors }, status: :unprocessable_entity
        end
      end

      def update
        user = User.find(params[:id])
        if user.update(user_params)
          render json: user, status: :ok
        else
          render json: { errors: user.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        user = User.find(params[:id])
        user.destroy
        head :no_content
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end

      private

      def user_params
        params.fetch(:user).permit(
          :name, :email, :password, :password_confirmation, :role
        )
      end
    end
  end
end
