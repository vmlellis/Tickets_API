module Api
  module V1
    class TicketsController < RestController
      private

      def resource_params
        params.fetch(:ticket).permit(:title, :description)
      end

      def model
        return current_user.created_tickets if current_user.customer?
        return current_user.support_tickets if current_user.agent?
        Ticket.all
      end
    end
  end
end
