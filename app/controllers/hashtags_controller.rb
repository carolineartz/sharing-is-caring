class HashtagsController < ApplicationController
    skip_authorization_check
    skip_before_action :authenticate_user!

  def index
    @hashtags = SimpleHashtag::Hashtag.all.order(:created_at).reverse_order
  end

  def show
    @hashtag = SimpleHashtag::Hashtag.find_by_name(params[:hashtag])
    @hashtagged = @hashtag.hashtaggables if @hashtag
  end

end
