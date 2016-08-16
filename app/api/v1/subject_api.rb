module V1
  class SubjectApi < Grape::API
    resources :subjects do
      desc "取得所有科目"

      get do
        subjects  = Subject.all
        categorys = Category.all

        present  :subjects, subjects,    with:     ::Entities::Subject,
                                         grades:     ArticleGrade.all,
                                         editions:   Edition.all
        present  :categorys, categorys,  with:     ::Entities::CategoryWithItem
      end
    end
  end
end
