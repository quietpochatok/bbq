require 'spec_helper'
require 'rails_helper'

RSpec.describe EventPolicy, type: :policy do
  let(:first_user) { create(:user) }
  let(:second_user) { create(:user) }
  let(:event) { create(:event, user: first_user) }

  # объект тестирования (политика)
  subject { described_class }

  context 'User use edit/destroy/update to event ' do
    context 'when user in an owner event' do
      permissions :edit?, :update?, :destroy? do
        it { is_expected.to permit(first_user, event) }
      end
    end

    context 'when user in not an owner event' do
      permissions :edit?, :update?, :destroy? do
        it { is_expected.not_to permit(second_user, event) }
      end
    end

    context 'when user is anon' do
      permissions :edit?, :update?, :destroy? do
        it { is_expected.not_to permit(nil, event) }
      end
    end
  end

  context 'User see to event page' do
    context 'when user in an owner event' do
      permissions :show? do
        it { is_expected.to permit(first_user, event) }
      end
    end

    context 'when user in not an owner event' do
      permissions :show? do
        it { is_expected.to permit(second_user, event) }
      end
    end

    context 'when user is anon' do
      permissions :show? do
        it { is_expected.to permit(nil, event) }
      end
    end
  end
end