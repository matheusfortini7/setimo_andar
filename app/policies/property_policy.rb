class PropertyPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
    def resolve
      scope.all
    end
  end

  def my?
    true
  end

  def filter?
    true
  end

  def show?
    return true
  end

  def create?
    return true
  end

  def new?
    return true
  end

  def edit?
    record.user == user
  end

  def update?
    record.user == user
  end

  def destroy?
    record.user == user
  end
end
