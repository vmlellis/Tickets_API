module Api
  module V1
    class TicketsController < RestController
      before_action :authenticate_customer!, only: %i[create]
      before_action :authenticate_admin!, only: %i[destroy]

      def create
        super do |ticket|
          ticket.created_by = current_user
          ticket.agent = User.random_agent
          ticket.status = 'new'
        end
      end

      private

      def resource_params
        params.fetch(:ticket).permit(*permitted_params)
      end

      def permitted_params
        if current_user.admin?
          %w[title description ticket_type_id status agent_id]
        elsif current_user.customer?
          %w[title description ticket_type_id]
        else
          %w[status]
        end
      end

      def model
        return current_user.created_tickets if current_user.customer?
        return current_user.support_tickets if current_user.agent?
        Ticket.all
      end
    end
  end
end
