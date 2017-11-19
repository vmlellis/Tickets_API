namespace :populate do
  desc 'Populate to test in development'
  task dev: :environment do
    15.times do |i|
      User.create(
        name: "Customer #{i + 1}",
        email: "customer#{i + 1}@customer.com",
        password: '123456',
        role: 'customer'
      )

      User.create(
        name: "Agent #{i + 1}",
        email: "agent#{i + 1}@agent.com",
        password: '123456',
        role: 'agent'
      )
    end

    [
      'Setup / Configuration', 'Service Request', 'Portal Issue',
      'Billing Support', 'Other'
    ].each do |type|
      TicketType.create(name: type)
    end
  end
end
