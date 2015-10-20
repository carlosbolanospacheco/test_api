class UserPolicy < ApplicationPolicy
  def index?
    return true if user.admin?
  end

  def show?
    return true if user.admin?
  end

  def create?
    return true if user.admin?
  end

  def update?
    return true if user.admin?
  end

  def destroy?
    return true if user.admin?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end
