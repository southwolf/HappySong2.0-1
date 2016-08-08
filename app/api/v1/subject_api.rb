module V1
  class SubjectApi < Grape::API
    resources :subjects do
      desc "取得所有科目"

      get do
        subjects  = Subject.all
        categorys = Category.all

        present  :subjects, subjects,    with:     ::Entities::Subject,
                                         grades:     Grade.all,
                                         editions:   Edition.all
        present  :categorys, categorys,  with:     ::Entities::Category
        status 200
      end
    end
  end
end
