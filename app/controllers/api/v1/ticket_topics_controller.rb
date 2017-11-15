module Api
  module V1
    class TicketTopicsController < RestController
      before_action :authenticate_admin!, only: %i[destroy]

      def create
        super do |ticket_topic|
          ticket_topic.user = current_user
        end
      end

      private

      def resource_params
        params.fetch(:ticket_topic).permit(:description)
      end

      def model
        ticket.ticket_topics
      end

      def ticket
        @ticket ||= tickets_by_role.find(params[:ticket_id])
      end

      def tickets_by_role
        return current_user.created_tickets if current_user.customer?
        return current_user.support_tickets if current_user.agent?
        Ticket.all
      end
    end
  end
end
