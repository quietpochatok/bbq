class EventPolicy < ApplicationPolicy
  def edit?
    update?
  end

  def destroy?
    update?
  end

  def show?
    true
  end

  def update?
    user_is_owner?(record)
  end

  class Scope < Scope
    def resolve
      # Event.where(user: user) if user.present?
      # scope.where(user: user) if user.present?
      scope.all
    end
  end

  private

  def user_is_owner?(model)
    user.present? && (model.try(:user) == user)
  end
end
