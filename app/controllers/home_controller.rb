class HomeController < ApplicationController
  def index
    @articles = Rails.cache.fetch "articles" do
      Article.except_body_with_default.order("id DESC").limit(10).to_a
    end
    @hot_articles = Rails.cache.fetch "hot_articles" do
      Article.except_body_with_default.select("visit_count").order("visit_count DESC").limit(10).to_a
    end
    @groups = Rails.cache.fetch("groups", expires_in: 2.hours) do
      Group.all.to_a
    end
    @site_info_home_desc = Rails.cache.fetch "site_info_home_desc" do
      Admin::SiteInfo.find_by(key: "home_desc").try(:value)
    end
    respond_to do |format|
      format.all { render :index, formats: [:html]}
    end
  end
end
