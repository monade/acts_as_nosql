require 'spec_helper'

describe 'Querying' do
  context 'simple attributes' do
    let!(:article) do
      Article.create!(
        body: 'body',
        published: true,
        comments_count: 5,
      )
    end

    let!(:article2) do
      Article.create!
    end

    it 'can be queried' do
      query = Article.where(body: 'body')
      expect(query.to_sql).to eq(
        "SELECT \"articles\".* FROM \"articles\" WHERE (\"articles\".\"data\"->>\"body\" = 'body')"
      )
      expect(query.to_a).to contain_exactly(article)
    end
  end

  context 'nested attributes' do
    let!(:setting) do
      Setting.create!(
        user_auth_token: '123123',
      )
    end

    let!(:setting2) do
      Setting.create!
    end

    it 'can query nested attributes' do
      query = Setting.where(user_auth_token: '123123')
      expect(query.to_sql).to eq(
        "SELECT \"settings\".* FROM \"settings\" WHERE (\"settings\".\"config\"->>\"user\"->>\"auth\"->>\"token\" = '123123')"
      )
      expect(query.to_a).to contain_exactly(setting)
    end
  end
end
