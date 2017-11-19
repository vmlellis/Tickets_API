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

      def update
        super do |ticket, attributes|
          if changed_to_closed?(ticket)
            attributes.merge!(closed_by: current_user, closed_at: Time.now)
          end
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
        if action_name == 'index' && params[:report_closed]
          model_by_role.status_closed.closed_in_last_month
        else
          model_by_role
        end
      end

      def model_by_role
        return current_user.created_tickets if current_user.customer?
        return current_user.support_tickets if current_user.agent?
        Ticket.all
      end

      def changed_to_closed?(ticket)
        closed_status = Ticket::STATUS.index('closed')
        closed_params = [closed_status.to_s, 'closed']
        closed_params.include?(resource_params[:status].to_s) &&
          ticket.status != closed_status
      end
    end
  end
end
