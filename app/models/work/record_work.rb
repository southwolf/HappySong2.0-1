# 朗读作业

class RecordWork < HomeWork

  # callback
  after_create :notify_students
  def notify_students
    unless Rails.env == 'test'
      NewNotificationJob.perform_later(teacher_id, 1, id, 'RecordWork')
    else
      NewNotification.create(actor_id: teacher_id, index: 1, targetable_id: id, targetable_type: 'RecordWork')
    end
  end

  # methods
  def build_record_work(article_ids, class_ids)
    begin
      @classes = Org::Class.where(id: class_ids)
      @classes.each do |org_class|
        class_works.create!(org_class: org_class)
      end

      @articles = Article.where(id: article_ids)
      self.avatar = ENV['QINIUPREFIX'] + @articles.first.try(:cover_img)
      self.save
      @articles.each do |article|
        article_works.create!(article: article)
      end
      return true
    rescue
      return false
    end
  end

  def materials
    []
  end
end
