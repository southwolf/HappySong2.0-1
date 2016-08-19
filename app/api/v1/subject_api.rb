module V1
  class SubjectApi < Grape::API
    resources :subjects do
      desc "取得所有科目"

      get do
        subjects  = Subject.all
        categorys = Category.all

        present  :subjects,  subjects,   with:     ::Entities::Subject,
                                         grades:     ArticleGrade.all,
                                         editions:   Edition.all
        present  :categorys, categorys,  with:     ::Entities::CategoryWithItem
      end

      desc "取得科目或分类"
      get '/get' do
        subjects  = Subject.all.to_a
        categorys = Category.all.to_a
        all       = (subjects << categorys).flatten
        present all, with: ::Entities::Custom
      end

      desc "用科目ID取其他数据"
      params do
        requires :subject_id, type: Integer, desc: '科目ID'
      end
      get '/other_data_use_subject' do
        subject_id = params[:subject_id]
        subject    = Subject.find(subject_id)
        articles   = subject.articles
        editions   = []
        grade_articles = []
        articles.each do |article|
          editions       << article.edition
          grade_articles << article.grade_article
        end
        editions         = editions.uniq
        grgrade_articles = grgrade_articles.uniq
        present :editions, editions, with: ::Entities::IdAndName
        present :grade_articles, grade_articles, with: ::Entities::IdAndName
      end

      desc "用分类ID取分类子项目"
      params do
        requires :category_id, type: Integer, desc: '类别ID'
      end
      get '/cate_item' do
        category_id = params[:category_id]
        category    = Category.find(category_id)
        cate_items   = category.cate_items

        present cate_items, with: ::Entities::CateItem
      end
    end
  end
end
