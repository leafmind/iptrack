# Geolocation API

A simple Rails API for storing and retrieving geolocation data based on an IP address or URL.

The application uses SQLite for persistence and can integrate with [IPStack](https://ipstack.com/) as an external geolocation provider. API responses follow the JSON:API specification.

## Features
* Store geolocation data for an IP address or URL
* Retrieve geolocation data by IP address or URL
* Delete stored geolocation data
* List stored geolocation data (admin only)
* Update stored geolocation data (admin only)
* API key authentication
* Authorization using Pundit policies
* Integration with IPStack for external geolocation lookup
* JSON:API-formatted responses

## Tech Stack
* Ruby 3.3.4
* Ruby on Rails 8.1.3
* SQLite
* RSpec
* Pundit
* Graphiti (JSON-API resources)
* IPStack API

## Installation

Clone the repository and install the dependencies:

`bundle install`

Prepare the database and seeds:

`bin/rails db:prepare`

Configure the required environment variables, including the IPStack `API_KEY` if you have one. If no key is provided, the application will use the default API key.

#### Endpoints

GET `/api/v1/geocodes` (admin-only)

GET `/api/v1/geocodes/<ip_or_domain>`

POST `/api/v1/geocodes`

PATCH `/api/v1/geocodes/<ip_or_domain>` (admin-only)

DELETE `/api/v1/geocodes/<ip_or_domain>`

Please ensure you have a valid `X-Api-Key` header.

## Application Structure

### Models

#### `ApiKey`

Represents an API key used to authenticate requests to the application. (unique index on token)

#### `Geocode`

Stores geolocation information associated with an IP address or URL. (unique index on target)

### Controllers

#### `GeocodesController`

Handles API requests related to geolocation records, including creating, retrieving, and deleting geocode data.

### Resources

#### `GeocodeResource`

Handles JSON:API compatible resource representations.

### Services

#### `RequestGeocodeService`

Encapsulates communication with the configured geolocation provider.

The service accepts a model and an API provider and delegates the geolocation lookup to the provider.

#### ApiProviders::IpStack
A client responsible for communicating with the IPStack API and retrieving geolocation information for an IP address or URL.

By default it uses my own api key, but feel free to redefine it by setting `API_KEY` env.

### Authorization

The application uses Pundit for authorization.

Policies determine whether an authenticated API user is allowed to perform operations against geolocation resources.

### API

The API uses JSON as its transport format and follows the JSON:API specification.

### Authentication

API requests require a valid API key. `X-Api-Key` header. (ApiKey token)
