require 'spec_helper'
require 'rails_helper'

RSpec.describe EventPolicy, type: :policy do
  # объект тестирования (политика)
  subject { described_class }
  let(:first_user) { create(:user) }
  let(:second_user) { create(:user) }
  let(:event) { create(:event, user: first_user) }

  let(:event_with_password) { create(:event, user: first_user, pincode: '777') }
  let(:valid_cookies) { { "events_#{event_with_password.id}_pincode" => '777'} }

  let(:first_user_from_context) { UserContext.new(first_user, {}) }
  let(:second_user_from_context) { UserContext.new(second_user, {}) }
  let(:anon_user_from_context) { UserContext.new(nil, valid_cookies) }

  context 'User use edit/destroy/update to event ' do
    context 'when user in an owner event' do
      permissions :edit?, :update?, :destroy? do
        it { is_expected.to permit(first_user_from_context, event) }
      end
    end

    context 'when user in not an owner event' do
      permissions :edit?, :update?, :destroy? do
        it { is_expected.not_to permit(second_user_from_context, event) }
      end
    end

    context 'when user is anon' do
      permissions :edit?, :update?, :destroy? do
        it { is_expected.not_to permit(anon_user_from_context, event) }
      end
    end
  end

  context 'User see to event page' do
    context 'when user in an owner event' do
      permissions :show? do
        it { is_expected.to permit(first_user_from_context, event) }
      end
    end

    context 'when user in not an owner event' do
      permissions :show? do
        it { is_expected.to permit(second_user_from_context, event) }
      end
    end

    context 'when user is anon' do
      permissions :show? do
        it { is_expected.to permit(anon_user_from_context, event) }
      end
    end
  end

  context 'User see to event page with pincode' do
    context 'when user in an owner event' do
      permissions :show? do
        it { is_expected.to permit(first_user_from_context, event_with_password) }
      end
    end

    context 'when user in not an owner event and not have pincode -> access denied' do
      permissions :show? do
        it { is_expected.not_to permit(second_user_from_context, event_with_password) }
      end
    end

    context 'when user is anon and have pincode' do
      permissions :show? do
        it { is_expected.to permit(anon_user_from_context, event_with_password) }
      end
    end
  end
end