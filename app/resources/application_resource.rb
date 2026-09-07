# frozen_string_literal: true

class ApplicationResource < Graphiti::Resource
  self.abstract_class = true
  self.adapter = Graphiti::Adapters::ActiveRecord

  # Otherwise it won't allow custom IDs
  self.validate_requests = false

  # INFO: Default resource settings
  self.attributes_readable_by_default = true
  self.attributes_writable_by_default = true
  self.attributes_sortable_by_default = true
  self.attributes_filterable_by_default = true

  # INFO: Used for link generation
  self.endpoint_namespace = '/api/v1'

  # INFO: Used for auth context
  def current_api_key
    context.current_api_key
  end
end