class EventPolicy < ApplicationPolicy
  def edit?
    update?
  end

  def destroy?
    update?
  end

  def show?
    user_can_see_event?(record)
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

  def user_can_see_event?(model)
    pincode = cookies["events_#{model.id}_pincode"]

    model.pincode.blank? || user_is_owner?(model) ||
      (model.pincode.presence && model.pincode_valid?(pincode))
  end
end
