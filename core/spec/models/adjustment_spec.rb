require 'spec_helper'

describe Adjustment do
  let(:order) { mock_model(Order, :update! => nil) }
  let(:adjustment) { Adjustment.new }
  it "should accept a negative amount"

  context "when amount is 0" do
    before { adjustment.amount = 0 }
    it "should be applicable if mandatory?" do
      adjustment.mandatory = true
      adjustment.applicable?.should be_true
    end
    it "should not be applicable unless mandatory?" do
      adjustment.mandatory = false
      adjustment.applicable?.should be_false
    end
  end

  context "#update" do
    context "when originator present" do
      let(:originator) { mock "originator" }
      before do
        originator.stub :update_amount => true
        adjustment.stub :originator => originator
      end
      it "should do nothing when frozen" do
        adjustment.frozen = true
        originator.should_not_receive(:update_amount)
        adjustment.update
      end
      it "should ask the originator to update_adjustment" do
        originator.should_receive(:update_adjustment)
        adjustment.update
      end
    end
    it "should do nothing when originator is nil" do
      adjustment.stub :originator => nil
      adjustment.should_not_receive(:amount=)
      adjustment.update
    end
  end

  context "#save" do
    it "should call order#update!" do
      adjustment = Adjustment.new(:order => order, :amount => 10, :label => "Foo")
      order.should_receive(:update!)
      adjustment.save
    end
  end
end