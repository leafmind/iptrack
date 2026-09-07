# frozen_string_literal: true

class GeocodePolicy
  attr_reader :api_key, :record

  def initialize(api_key, record)
    @api_key = api_key
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    def initialize(api_key, scope)
      @api_key = api_key
      @scope = scope
    end

    def resolve
      raise NoMethodError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :api_key, :scope
  end
end
