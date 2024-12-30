# URL Shortener

This project is a simple URL shortener application built with Ruby on Rails. It provides a web interface and an API for creating and managing short URLs.

## Features
- Web interface to shorten URLs
- API endpoint to shorten URLs with token-based authentication
- Documentation using Swagger (rswag)
- PostgreSQL database support

## Requirements
- Ruby 3.2.1
- Rails 7.x
- PostgreSQL

## Setup Instructions

### 1. Clone the Repository
```bash
git clone <repository_url>
cd <repository_name>
```

### 2. Install Dependencies
```bash
bundle install
```

### 3. Configure Database
Create and configure the `config/database.yml` file for your PostgreSQL setup:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: 5
  username: <your_username>
  password: <your_password>
  host: localhost

development:
  <<: *default
  database: url_shortener_development

test:
  <<: *default
  database: url_shortener_test

production:
  <<: *default
  database: url_shortener_production
  username: <production_username>
  password: <production_password>
```

Run the following commands to set up the database:
```bash
rails db:create
rails db:migrate
```

### 4. Add API Token
Set a static API token in the Rails configuration:

Add this line to `config/application.rb`:
```ruby
config.api_token = '<your_api_token>'
```

### 5. Start the Server
```bash
rails server
```

Visit `http://localhost:3000` to use the application.

## API Endpoints

### Base URL
`http://localhost:3000`

### POST `/api/v1/urls`
**Description**: Shorten a URL.

#### Headers
- `Authorization`: `<your_api_token>`

#### Request Body (JSON)
```json
{
  "url": {
    "original_url": "https://example.com"
  }
}
```

#### Response
- **Success (200)**:
  ```json
  {
    "short_url": "http://localhost:3000/<short_url>",
    "message": "URL shortened successfully"
  }
  ```
- **Error (422)**:
  ```json
  {
    "errors": ["Original url can't be blank"]
  }
  ```

## Swagger Documentation
Swagger UI is available at:
`http://localhost:3000/api-docs`

Generate the Swagger documentation:
```bash
rake rswag:specs:swaggerize
```

## Running Tests

### RSpec Tests
Run the test suite:
```bash
rspec
```

### Swagger Specs
Ensure API documentation is generated correctly:
```bash
rake rswag:specs:swaggerize
```

## Additional Notes
- Use `Postman` or `cURL` to test the API endpoints.
- Ensure your PostgreSQL server is running before starting the application.
- Customize the API token in production for added security.

# we can use here jwt, devise-jwt for token but as i did not implemented any user feature login, signup so i prefer static token here for authentication.
curl --location 'http://localhost:3000/api/v1//create_shorten_url' \
--header 'Content-Type: application/json' \
--header 'Authorization: your_static_token' \
--data '{
  "url": {
    "original_url": "https://googl9.com"
  }
}
'
