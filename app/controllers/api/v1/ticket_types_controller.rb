module Api
  module V1
    class TicketTypesController < RestController
      before_action :authenticate_admin!

      private

      def resource_params
        params.fetch(:ticket_type).permit(:name)
      end
    end
  end
end
