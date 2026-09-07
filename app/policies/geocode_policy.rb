# frozen_string_literal: true

class GeocodePolicy < ApplicationPolicy

  def index?
    api_key.admin?
  end

  def show?
    api_key.user?
  end

  def create?
    api_key.user?
  end

  def new?
    create?
  end

  def update?
    api_key.admin?
  end

  def edit?
    update?
  end

  def destroy?
    api_key.user?
  end
end
