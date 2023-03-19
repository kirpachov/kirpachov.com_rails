# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  # Factory definition
  let(:project) { create(:project) }

  # Validations
  describe "validations" do
    describe 'if wip?' do
      before { allow(subject).to receive(:wip?).and_return(true) }
      it { is_expected.to validate_presence_of(:start_date) }
      it { expect(subject.done?).to be false } # double check to see if next test has any effect
    end

    describe 'if done?' do
      before { allow(subject).to receive(:done?).and_return(true) }
      it { is_expected.to validate_presence_of(:end_date) }
      it { expect(subject.wip?).to be false } # double check to see if previous test has any effect
    end
  end

  # Instance methods
  describe "#set_defaults" do
    it "sets status to 'pending' by default" do
      expect(project.status).to eq('pending')
    end

    it "removes blank strings from production_urls array" do
      project.production_urls = ["http://example.com", "", "   "]
      project.set_defaults
      expect(project.production_urls).to eq(["http://example.com"])
    end
  end

  describe "#start!" do
    it "sets start_date to today's date" do
      project.start!
      expect(project.start_date).to eq(Date.today)
    end

    it "changes status to 'wip' if status is 'pending'" do
      project.status = 'pending'
      project.start!
      expect(project.status).to eq('wip')
    end
  end

  describe "#end!" do
    it "sets end_date to today's date" do
      project.end!
      expect(project.end_date).to eq(Date.today)
    end

    it "changes status to 'done' if status is 'wip'" do
      project.status = 'wip'
      project.end!
      expect(project.status).to eq('done')
    end
  end
end

