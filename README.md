# Install and configure prerequisites or dependencies

- Install the gems:
```
bundle install
```
- Put this line in the hosts file:
```
127.0.0.1 api.tickets.dev
```

# Create and initialize the database
- Create database:
```
rake db:create
```
- Run migrations:
```
rails db:migrate
```
- Populate:
```
rails db:seed
```
