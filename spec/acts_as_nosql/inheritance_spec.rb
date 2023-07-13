require 'spec_helper'

describe 'Inheritance' do
  subject { InheritedSetting.new }
  it 'inherits all methods from Settings' do
    expect(subject).to respond_to(:user_auth_token)
    expect(subject).to respond_to(:user_auth_token=)

    subject.user_auth_token = '3'
    expect(subject.user_auth_token).to eq('3')
    subject.save!
    expect do
      expect(InheritedSetting.where(user_auth_token: '3')).to eq([subject])
    end.to_not raise_error
  end

  it 'can be estended without affecting the parent' do
    InheritedSetting.nosql_attrs :hello, type: :String
    expect(subject).to respond_to(:hello)
    expect(Setting.new).not_to respond_to(:hello)
  end
end
