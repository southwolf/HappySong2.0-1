module V1
  class SchoolManagerApi < Grape::API
    namespace :school_manager do
      resources :provinces do
        desc '查询所有省份'
        get '/all' do
          provinces = Province.all
          present provinces, with: ::Entities::Province
        end

        desc '新建省份'
        params do
          requires :name, type: String, desc: '省名称'
        end
        post '/create' do
          province = Province.new( :name => params[:name].to_s)
          if province.save
            present province, with: ::Entities::Province
          else
            error!("失败", 500)
          end
        end

        desc '更新省份信息'
        params do
          requires :id,   type: Integer, desc: '省ID'
          requires :name, type: String,  desc: '省份名称'
        end
        post '/update' do
          province = Province.find(params[:province_id])
          if province.update( :name => params[:name])
            present province, with: ::Entities::Province
          else
            error!("失败", 500)
          end
        end
      end

      resources :cities do
        desc '查询所有市'
        get '/all' do
          cities = City.all
          present cities, with: ::Entities::City
        end

        desc '根据省份查询城市'
        params do
          requires :province_id, type: Integer, desc: '省份ID'
        end
        get '/search' do
          province = Province.find(params[province_id])
          cities   = province.cities
          present cities, with: ::Entities::City
        end

        desc '新建城市'
        params do
          requires :name,        type: String,  desc:'城市名'
          requires :province_id, type: Integer, desc: '省ID'
        end
        post '/create' do
          province = Province.find(params[:province_id])
          city     = province.cities.build(:name => params[:name])
          if city.save
            present city, with: ::Entities::City
          else
            error!("失败", 500)
          end
        end

        desc '更新城市信息'
        params do
          requires :id,          type: Integer, desc: '城市ID'
          requires :province_id, type: Integer, desc: '省id'
          requires :name,        type: String,  desc: '城市名称'
        end
        post '/update' do
          city = City.find(params[:id])
          if city.update( :province_id => params[:province_id],
                          :name        => params[:name])
            present city, with: ::Entities::City
          else
            error!("失败", 500)
          end
        end
      end

      resources :districts do
        desc '查询所有区域'
        get '/all' do
          districts = District.all
          present districts, with: ::Entities::District
        end

        desc '新建区域'
        params do
          requires :name,    type: String,  desc: '区域名称'
          requires :city_id, type: Integer, desc: '城市ID'
        end
        post '/create' do
          city = City.find(params[:city_id].to_i)
          district = city.districts.build(:name => params[:name])
          if district.save
            present "成功"
          else
            error!("失败", 500)
          end
        end

        desc '更新区域信息'
        params do
          requires :id,      type: Integer, desc: '区域ID'
          requires :name,    type: String,  desc: '区域名称'
          requires :city_id, type: Integer, desc: '城市ID'
        end
        post '/update' do
          district = District.find(params[:id])
          if district.update( :name    => params[:name],
                              :city_id => params[:city_id])
            present "成功"
          else
            error!("失败", 500)
          end
        end
      end
      
      resources :school do
        desc '根据区域id查学校'
        params do
          requires :district_id, type: Integer, desc: '区域Id'
        end
        get '/search' do
          district = District.find(params[:district_id])
          schools  = district.schools
          present schools, with: ::Entities::City
        end

        desc '新建学校'
        params do
          requires :name,        type: String,  desc: '学校名称'
          requires :district_id, type: Integer, desc: '区域ID'
        end
        post '/create' do
          district = District.find(params[:district_id])
          school   = district.schools.build(:name => params[:name])
          if school.save
            present "成功"
          else
            error!("失败", 500)
          end
        end

        desc '更新学校信息'
        params do
          requires :id,          type: Integer, desc: '学校ID'
          requires :name,        type: String,  desc: '学校名称'
          requires :district_id, type: Integer, desc: '区域ID'
        end
        post '/update'do
          school = School.find(params[:id])
          if school.update(:name => params[:name], :district_id => params[:district_id])
            present "成功"
          else
            error!("失败", 500)
          end
        end

        desc '为学校添加年级'
        params do
          requires :id,       type: Integer, desc: '学校ID'
          requires :grade_id, type: Integer, desc: '年级ID'
        end
        post '/add_grade' do
          school = School.find(params[:id])
          grade  = Grade.find(params[:grade_id])
          if school.grades << grade
            present "成功"
          else
            error!("失败", 500)
          end
        end

        desc '为学校添加班级'
        params do
          requires :id,    type: Integer, desc: '学校ID'
          requires :team_class_id, type: Integer, desc: '班级ID'
        end

        post '/add_team_class' do
          school = School.find(params[:id])
          team_class = TeamClass.find(params[:team_class_id])
          if school.team_classes << team_class
            present "成功"
          else
            error!("失败", 500)
          end
        end
      end

      resources :grade do
        desc '新建年级'
        params do
          requires :name, type: String, desc: '年级名称'
        end
        post '/create' do
          grade = Grade.new( :name => params[:name])
          if grade.save
            present :garde, with: ::Entities::Grape
          else
            error!("失败", 500)
          end
        end

        desc '更新年级信息'
        params do
          requires :id,   type: Integer, desc: '年级ID'
          requires :name, type: String,  desc: '年级名称'
        end
        post '/update' do
          grade = Grade.find(params[:id])
          if grade.update( :name => params[:name])
            present grade, with: ::Entities::Grape
          else
            error!("失败", 500)
          end
        end

        desc '取得所有年级信息'
        get '/all' do
          grades = Grade.all
          present grades, with: ::Entities::Grape
        end
      end

      resources :team_classes do
        desc '新建班级'
        params do
          requires :name, type: String, desc: '班级名称'
        end
        post '/create' do
          team_class = TeamClass.new( :name => params[:name])
          if team_class.save
            present team_class, with: ::Entities::TeamClass
          else
            error!("失败", 500)
          end
        end

        desc '更新班级信息'
        params do
          requires :id,   type: Integer, desc: '班级ID'
          requires :name, type: String,  desc: '班级名称'
        end
        
        post '/update' do
          team_class = TeamClass.find(params[:id])
          if team_class.update( :name => params[:name])
            present team_class, with: ::Entities::TeamClass
          else
            error!("失败", 500)
          end
        end

        desc '取得所有班级信息'
        get '/all' do
          team_classes = TeamClass.all
          present team_classes, with: ::Entities::TeamClass
        end
      end


      resources :subjects do
        desc '创建科目'
        params do
          requires :name, type: String, desc: '科目名称'
        end
        post do
          subject = Subject.new(name: params[:name].to_s)
          if subject.save
            present "成功"
          else
            error!("失败", 500)
          end
        end
      end

      resources :units do
        desc '创建单元'
        params do
          requires :name, type: String, desc: '单元名称'
        end

        post do
          unit = Unit.new(name: params[:name].to_s)
          if unit.save
            present "成功"
          else
            error!("失败", 500)
          end
        end
      end

      resources :editions do
        desc '创建版本'
        params do
          requires :name, type: String, desc: '版本名称'
        end

        post do
          edition = Edition.new(name: params[:name].to_s)
          if edition.save
            present "成功"
          else
            error!("失败", 500)
          end
        end
      end
      
      resources :article_grades do
        desc '创建文章年级'
        params do
          requires :name, type: String, desc: '文章年级名称'
        end
        post do
          article_grades = ArticleGrade.new(name: params[:name].to_s)
          if article_grades.save
            present "成功"
          else
            error!("失败",500)
          end
        end
      end

      resources :articles do
        desc '创建课内文章'
        params do
          requires :title,            type: String,  desc: '标题'
          requires :cover_img,        type: String,  desc: '封面'
          requires :subject_id,       type: Integer, desc: '科目Id'
          requires :article_grade_id, type: Integer, desc: '文章年级ID'
          requires :edition_id,       type: Integer, desc: '版本ID'
          requires :unit_id,          type: Integer, desc: '单元ID'
          requires :content,          type: String,  desc: '文章内容'
          requires :author,           type: String,  desc:  '作者'
        end

        post '/within' do
          article = Article.new(title:            params[:title],
                                cover_img:        params[:cover_img],
                                subject_id:       params[:subject_id],
                                article_grade_id: params[:article_grade_id],
                                unit_id:          params[:unit_id],
                                content:          params[:content],
                                author:           params[:author])
          if article.save
            present "成功"
          else
            error!("失败", 500)
          end
        end
        
        desc '创建课外内容'
        params do
          requires :title,        type: String,  desc: '标题'
          requires :cover_img,    type: String,  desc: '封面'
          requires :content,      type: String,  desc: '文章内容'
          requires :cate_item_id, type: Integer, desc: '分类项目ID'
        end
        post '/extra' do
          article = Article.new( title:     params[:title],
                                 cover_img: params[:cover_img],
                                 content:   params[:content])

          cate_item = CateItem.find(params[:cate_item_id])
          if article.cate_items << cate_item
            present "成功"
          else
            error!("失败", 500)
          end
        end
      end

      resources :categorys do

        desc '新建分类'
        params do
          requires :name, type: String, desc: '分类名称'
        end
        post '/new_cate' do
          category = Category.new( name: params[:name])
          if category.save
            present "成功"
          else
            error("失败", 500)
          end
        end

        desc '查询所有分类'
        get '/all' do
          categorys = Category.all
          present categorys, with: ::Entities::SimpleCategory
        end

        desc '新建分类子项目'
        params do
          requires :category_id, type: Integer, desc: '类别ID'
          requires :name,        type: String,  desc: '名称'
        end
        post '/new_cate_item' do
          category = Category.find(:category_id)
          if category.cate_items.create(name: params[:name])
            present "成功"
          else
            error!("失败", 500)
          end
        end
      end
      resources :music_types do
        desc "新建音乐类型"
        params do
          requires :name, type: String, desc: '类型名称'
        end
        post '/create' do
          music_type = MusicType.new(:name => params[:name])
          if music_type.save
            present :music_type, with: ::Entities::MusicType
          else
            error!("失败", 500)
          end
        end
      end

      resources :musics do
        desc '新建音乐'
        params do
          requires :file_url,      type: String,  desc: '音乐key'
          requires :music_type_id, type: Integer, desc: '音乐类型'
        end

        post '/create' do
          music_type = MusicType.find(params[:music_type_id])
          music = music_type.musics.build( :file_url => params[:file_url])
          if music.save
            present music, with: ::Entities::Music
          else
            error!("失败", 500)
          end
        end
      end
    end
  end
end
