# frozen_string_literal: true

class ApplicationPolicy
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
end
