require 'spec_helper'

describe 'Nested fields declaration' do

  subject { Setting.new }

  it 'has declared fields' do
    expect(subject).to respond_to(:user_auth_token)
    expect(subject).to respond_to(:user_auth_token=)
  end

  it 'uses default values' do
    expect(subject.user_auth_token).to eq('')
  end

  it 'casts fields' do
    subject.user_auth_token = 2
    expect(subject.user_auth_token).to eq('2')
  end

  it 'writes nested values' do
    subject.user_auth_token = 2
    expect(subject.config).to eq({ 'user' => { 'auth' => { 'providers' => [], 'token' => '2' } } })
  end

  it 'data is persisted' do
    subject.user_auth_token = 2
    subject.save!
    subject.reload
    expect(subject.user_auth_token).to eq('2')
    expect(subject.config).to eq({ 'user' => { 'auth' => { 'providers' => [], 'token' => '2' } } })
  end

  context 'with array type' do
    it 'handles writes' do
      expect(subject.user_auth_providers).to eq([])
      subject.user_auth_providers = ['google']
      expect(subject.user_auth_providers).to eq(['google'])
      subject.save!
      subject.reload
      expect(subject.config).to eq({ 'user' => { 'auth' => { 'providers' => ['google'], 'token' => '' } } })
    end

    it 'handles mutation' do
      expect(subject.user_auth_providers).to eq([])
      subject.user_auth_providers << 'google'
      expect(subject.user_auth_providers).to eq(['google'])
      subject.save!
      subject.reload
      expect(subject.config).to eq({ 'user' => { 'auth' => { 'providers' => ['google'], 'token' => '' } } })
    end
  end
end
