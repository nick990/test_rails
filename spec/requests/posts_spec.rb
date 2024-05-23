require 'rails_helper'

RSpec.describe 'Post' do

  describe 'GET /api/posts' do
    it 'lists posts' do
      post = Post.create!(title: 'Foo', tags: [Tag.new(name: 'bar')])

      get api_posts_path(format: 'json')
      expect(response).to be_successful

      json = JSON.parse(response.body)
      expect(json).to be_a(Array)
      expect(json[0]['title']).to eq(post.title)
      expect(json[0]['tags'].count).to eq(post.tags.count)
      expect(json[0]['tags'].first['name']).to eq(post.tags.first.name)
    end
  end

  describe 'GET /api/posts/search?term=cane' do
    it 'lists posts with filter' do
      #post3 e post5 non devono essere tornati dall'API
      post1 = Post.create!(title: 'Il mio cane', tags: [Tag.new(name: 'gatto')])
      post2 = Post.create!(title: 'cane', tags: [Tag.new(name: 'gatto')])
      post3 = Post.create!(title: 'elefante', tags: [Tag.new(name: 'giraffa'),Tag.new(name: 'elefante')])
      post4 = Post.create!(title: 'giraffa', tags: [Tag.new(name: 'giraffa'),Tag.new(name: 'cane')])
      post5 = Post.create!(title: 'scimmia', tags: [Tag.new(name: 'giraffa'),Tag.new(name: 'il mio cane')])

      get search_api_posts_path(format: 'json', term: 'cane')
      expect(response).to be_successful

      json = JSON.parse(response.body)
      expect(json).to be_a(Array)
      expect(json.length).to eq(3)
      expect(json[0]['title']).to eq(post1.title)
      expect(json[1]['title']).to eq(post2.title)
      expect(json[2]['title']).to eq(post4.title)
      
    end
  end
end
