# 朗读作业

class RecordWork < HomeWork  
  # methods
  def build_record_work(article_ids, class_ids) #TODO Maybe ActiceJob
    # TODO bulk_insert
    begin
      @classes = Org::Class.where(id: class_ids)
      @classes.each do |org_class|
        class_works.create!(org_class: org_class)
      end

      @articles = Article.where(id: article_ids)
      @articles.each do |article|
        article_works.create!(article: article)
      end
      return true
    rescue
      return false
    end
  end
end
