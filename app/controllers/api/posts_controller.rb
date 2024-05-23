class Api::PostsController < ApplicationController
  def index
    @posts = Post.includes(:tags).all

    render json: serialize_posts(@posts)
  end

  def search
    term = params[:term]
    @posts = Post.includes(:tags).where('title LIKE ?', "%#{term}%")
    render json: serialize_posts(@posts)
  end

  def serialize_posts(posts)
    @posts.map do |post|
      {
        title: post.title,
        id: post.id,
        tags: post.tags.map { |tag| { name: tag.name } }
      }
    end
  end
end
