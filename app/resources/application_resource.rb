class ApplicationResource < Graphiti::Resource
  self.abstract_class = true
  self.adapter = Graphiti::Adapters::ActiveRecord

  # INFO: Default resource settings
  self.attributes_readable_by_default = true
  self.attributes_writable_by_default = true
  self.attributes_sortable_by_default = true
  self.attributes_filterable_by_default = true

  # INFO: Used for link generation
  self.base_url = ENV.fetch('BASE_URL', 'http://localhost:3000')
  self.endpoint_namespace = '/api/v1'

  # INFO: Used for auth context
  def api_key
    context.api_key
  end
end