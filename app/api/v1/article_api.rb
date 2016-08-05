module V1
  class ArticleApi < Grape::API
    include Grape::Kaminari
    paginate per_page: 20

    resources :articles do

      desc "获取所有文章"
      get '/all' do
        articles = Article.all.order(:records_count => :DESC)
        present paginate(articles), with: ::Entities::Article
      end

      desc "根据科目条件取文章"
      params do
        requires :subject_id,       type: Integer, desc:"科目ID"
        requires :edition_id,       type: Integer, desc:"版本ID"
        requires :article_grape_id, type: Integer, desc: "文章班级ID"
      end
      get do
        subject_id = params[:subject_id]
        edition_id = params[:edition_id]
        articles = Article.where(:subject_id => subject_id, :edition_id => edition_id)
                          .order(:records_count => :DESC)
        present paginate(articles), with: ::Entities::Article
      end

      desc '查询文章根据分类查询.'
      params do
        requires :cate_item_id, type: Integer, desc: 'cate_item id.'
      end
      get :category do
        cate_item_id = params[:cate_item_id]
        cate_item    = CateItem.find cate_item_id
        articles     = cate_item.articles.order(:records_count => :DESC)

        present paginate(articles), with: ::Entities::Article
      end

      desc "根据文章名取文章"
      params do
        optional :title, type: String, desc: "文章标题"
      end

      get '/search' do
        title = params[:title]
        articles = Article.all.order(:records_count => :DESC) if title.empty?
        articles = Article.where(title: title).order(:records_count => :DESC)

        if article.nil?
          error!("没有找到符合的文章", 404)
        else
          present  articles, with: ::Entities::Article
        end
      end
    end
  end
end
