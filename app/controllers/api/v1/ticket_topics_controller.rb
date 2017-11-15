module Api
  module V1
    class TicketTopicsController < RestController
      private

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
