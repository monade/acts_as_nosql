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

  it 'raises error if there\'s a name conflict an actual column' do
    expect { Article.nosql_attr :title }.to raise_error("Attribute title already defined")
  end

  it 'raises error if there\'s a name conflict an existing nosql attribute' do
    expect { Article.nosql_attr :body }.to raise_error("Attribute body already defined")
  end

  it 'raises error if there\'s a name conflict' do
    expect { Article.nosql_attr :some_column }.to raise_error("Attribute some_column already defined")
  end

  it 'raises error if there\'s a name conflict when calling #acts_as_nosql_check_conflicts!' do
    expect do
      class ConflictingArticle < ActiveRecord::Base
        self.table_name = 'articles'
        acts_as_nosql field_name: :data

        nosql_attrs :title, :editor, type: String
      end
    end.not_to raise_error("Attribute title already defined")

    expect { ConflictingArticle.acts_as_nosql_check_conflicts! }.to raise_error("Attribute title already defined")
  end

  it 'raises error if there\'s a name conflict when the model columns are loaded' do
    expect do
      class ConflictingArticle2 < ActiveRecord::Base
        self.table_name = 'articles'
        acts_as_nosql field_name: :data

        nosql_attrs :title, :editor, type: String
      end
    end.not_to raise_error("Attribute title already defined")

    expect { ConflictingArticle2.new }.to raise_error("Attribute title already defined")
  end

  it 'fields are saved as string' do
    subject.editor = 'John Doe'
    subject.save!
    subject.reload
    expect(subject.editor).to eq('John Doe')
    expect(subject.data['editor']).to eq('John Doe')
    expect(subject.data[:editor]).to eq(nil)
    expect(subject.data.keys.first).to be_a(String)
  end
end
