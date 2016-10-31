module V1
  class ArticleApi < Grape::API
    include Grape::Kaminari


    resources :articles do
      desc "获取所有文章"
      paginate per_page: 20
      get '/all' do
        articles = Article.all.order(:records_count => :DESC)
        present paginate(articles), with: ::Entities::Article
      end


      desc "获取文章的示范朗读"
      paginate per_page: 20
      params do
        requires :article_id, type: Integer, desc: "文章ID"
      end
      get '/demo_records' do
        article = Article.find(params[:article_id])
        demo_records = article.records.where(:is_demo => true, :is_public => true)
        present paginate(demo_records), with: ::Entities::Record
      end


      desc "根据科目条件取文章"
      paginate per_page: 20
      params do
        requires :subject_id,       type: Integer, desc:"科目ID"
        requires :edition_id,       type: Integer, desc:"版本ID"
        requires :article_grade_id, type: Integer, desc: "文章班级ID"
      end
      get do
        subject_id = params[:subject_id]
        edition_id = params[:edition_id]
        article_grade_id = params[:article_grade_id]
        articles = Article.where(:subject_id => subject_id, :edition_id => edition_id,:article_grade_id => article_grade_id)
                          .order(:records_count => :DESC)
        present paginate(articles), with: ::Entities::Article

      end

      desc '根据分类查询文章.'
      paginate per_page: 20
      params do
        requires :cate_item_id, type: Integer, desc: 'cate_item id.'
      end
      get :category do
        cate_item_id = params[:cate_item_id]
        cate_item    = CateItem.find cate_item_id
        articles     = cate_item.articles.order(:records_count => :DESC).includes(:records)

        present paginate(articles), with: ::Entities::FullArticle

      end

      desc "根据文章标题查询文章"
      params do
        optional :q, type: String, desc: "查询标识"
      end

      get '/search' do
        q = params[:q]
        articles = Article.all.order(:records_count => :DESC).includes(:records) if q.nil?
        articles = Article.where("title like ?", "#{q}%").order(:records_count => :DESC).includes(:records).includes(:records, records: [:user, user:[:role,:grade_team_class]])

        # if article.blank?
          # error!("没有找到符合的文章", 404)
        # else
        present  articles, with: ::Entities::FullArticle

        # end
      end

      desc "查看文章"
      params do
        requires :id, type: Integer, desc: '文章ID'
      end
      get '/show' do
        id    = params[:id]
        article = Article.find(id)
        if article.nil?
          error!("没找到",404)
        else
          present article, with: ::Entities::FullArticle
        end
      end

      desc "根据文章ID查看文章的所有朗读作品"
      paginate per_page: 20
      params do
        requires :id, type: Integer, desc: '文章ID'
      end
      get '/records_info' do
        id = params[:id]
        article = Article.find(id)
        records = article.public_records.order(:is_demo => :desc).order(:created_at => :desc).includes(:user, :music, :article, user:[:role])
        present paginate(records), with: ::Entities::Record
      end
    end
  end
end
