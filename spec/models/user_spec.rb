require 'rails_helper'

RSpec.describe User, type: :model do
  it "Check the author of the object" do
    user = create( :user )
    question = create( :question )
    expect(user.author_of?(question)).to eq false
    expect(User.new.author_of?(question)).to eq false
    expect(question.user.author_of?(question)).to eq true
  end

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
end
