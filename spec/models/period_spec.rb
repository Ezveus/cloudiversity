require 'spec_helper'

describe Period do
  before(:each) do
    @period_attributes = FactoryGirl.attributes_for(:period)
  end

  it 'should create a valid period' do
    create(:period)
  end

  it 'should be searchable by index and by name' do
    create(:period).tap do |period|
      expect(Period.find(period.id)).to eq(period)
    end
  end

  describe 'start_date' do
    it 'should require a start date' do
      build(:period).tap do |period|
        period.start_date = nil
        expect(period).not_to be_valid
      end
    end
  end

  describe 'end_date' do
    it 'should require a end date' do
      build(:period).tap do |period|
        period.end_date = nil
        expect(period).not_to be_valid
      end
    end

    it 'should reject invalid end date' do
      build(:period).tap do |period|
        period.start_date = '2014-06-27'
        period.end_date = '2014-06-26'
        expect(period).not_to be_valid
      end
    end

    it 'should allow a one day period' do
      build(:period).tap do |period|
        period.start_date = '2014-06-27'
        period.end_date = '2014-06-27'
        expect(period).to be_valid
      end
    end
  end

  describe 'name' do
    it 'should require a name' do
      build(:period).tap do |period|
        period.name = nil
        period.name.nil? ? nil : period.name.parametrize
        expect(period).not_to be_valid
      end
    end

    it 'should be unique' do
      create(:period).tap do |period1|
        build(:period).tap do |period2|
          period2.name = period1.name
          expect(period2).not_to be_valid
        end
      end
    end
  end
end
