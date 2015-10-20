class CongressPolicy < ApplicationPolicy
  def index?
    return true
  end

  def show?
    return true
  end

  def create?
    if record
      return true if record.user_id == user.id
    else
      return true # not necessary to check to create a new congress, already checked there's a logged user
    end
  end

  def update?
    return true if user.admin?
    return true if record.user_id == user.id
  end

  def destroy?
    return true if user.admin?
    return true if record.user_id == user.id
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end
