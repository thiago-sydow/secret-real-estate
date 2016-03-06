class PropertyPolicy < ApplicationPolicy

  def create?
    !user.guest?
  end

  def update?
    return false if is_guest?
    user.admin? || is_mine?
  end

  def destroy?
    return false if is_guest?
    user.admin? || is_mine?
  end

  private

  def is_mine?
    user == record.user
  end

end
