require 'spec_helper'

describe 'Fields declaration' do

  subject { Article.new }

  it 'has declared fields' do
    expect(subject).to respond_to(:body)
    expect(subject).to respond_to(:body=)
    expect(subject).to respond_to(:comments_count)
    expect(subject).to respond_to(:comments_count=)
    expect(subject).to respond_to(:published)
    expect(subject).to respond_to(:published=)
  end

  it 'uses default values' do
    expect(subject.comments_count).to eq(0)
    expect(subject.published).to eq(false)
    expect(subject.body).to eq(nil)
  end

  it 'casts fields' do
    subject.body = 2
    expect(subject.body).to eq('2')

    subject.published = '1'
    expect(subject.published).to eq(true)

    subject.comments_count = '1'
    expect(subject.comments_count).to eq(1)
  end

  it 'raises error if there\'s a name conflict with the field_name' do
    expect { Article.nosql_attr :data }.to raise_error("Attribute data already defined")
  end

  it 'raises error if there\'s a name conflict' do
    expect { Article.nosql_attr :some_column }.to raise_error("Attribute some_column already defined")
  end
end
