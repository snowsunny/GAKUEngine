require 'spec_helper'

describe Gaku::Lesson do

  context "validations" do 
    it { should belong_to(:lesson_plan) }
    it { should have_many(:attendances) } 
  end
end
