RSpec.describe Session, type: :model do
  describe "scopes" do
    describe ".future" do
      subject(:future) { described_class.future }

      let(:past_session) { create(:session, start_at: 1.minute.ago) }
      let(:future_session) { create(:session, start_at: 1.minute.from_now) }

      it { is_expected.to contain_exactly(future_session) }
    end
  end

  describe "validations" do
    describe "dates in order" do
      let(:session) { build(:session, start_at: 30.minutes.from_now, end_at: 29.minutes.from_now) }

      it "sets expected error" do
        expect(session.valid?).to be false
        expect(session.errors[:end_at]).to contain_exactly("must be after start date")
      end
    end

    describe "dates in future" do
      let(:session) { build(:session, start_at: 40.minutes.ago, end_at: 10.minutes.ago) }

      it "sets expected error" do
        expect(session.valid?).to be false
        expect(session.errors[:end_at]).to contain_exactly("must be in future")
        expect(session.errors[:start_at]).to contain_exactly("must be in future")
      end
    end
  end
end
