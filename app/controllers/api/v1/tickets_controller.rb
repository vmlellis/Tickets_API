module Api
  module V1
    class TicketsController < RestController
      before_action :authenticate_customer!

      def create
        super do |ticket|
          ticket.created_by = current_user
          ticket.agent = User.random_agent
        end
      end

      private

      def resource_params
        params.fetch(:ticket).permit(
          :title, :description, :ticket_type_id, :status
        )
      end

      def model
        return current_user.created_tickets if current_user.customer?
        return current_user.support_tickets if current_user.agent?
        Ticket.all
      end
    end
  end
end
