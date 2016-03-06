class UserPolicy < ApplicationPolicy

  def create?
    user.admin?
  end

  def update?
    user.admin? || is_self?
  end

  def destroy?
    return false if is_guest?
    user.admin? || is_self?
  end

  private

  def is_self?
    user == record
  end

end
