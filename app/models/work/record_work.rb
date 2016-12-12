# 朗读作业

class RecordWork < HomeWork

  # callback
  after_create :notify_students
  def notify_students
    # index 1 代表作业
    ans = NewNotification.create(actor_id: teacher_id, index: 1, targetable_id: id, targetable_type: 'RecordWork')
    binding.pry
  end

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
