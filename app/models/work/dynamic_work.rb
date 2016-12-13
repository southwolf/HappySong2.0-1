# 创作作业 -> materials 素材
class DynamicWork < HomeWork

  # associations
  has_many :materials, as: :materialable , class_name: 'Material'

  # callback
  after_create :notify_students
  def notify_students
    unless Rails.env == 'test'
      NewNotificationJob.perform_later(teacher_id, 1, id, 'DynamicWork')
    else
      NewNotification.create(actor_id: teacher_id, index: 1, targetable_id: id, targetable_type: DynamicWork)
    end
  end

  # methods
  def build_dynamic_work(qiniu_files, class_ids)
    begin
      self.avatar = ENV['QINIUPREFIX'] + qiniu_files[0]['url']
      self.save
      qiniu_files.each do |file|
        materials.create!(url: file['url'], kind: file['type'])
      end

      @classes = Org::Class.where(id: class_ids) # 相关的班级
      @classes.each do |org_class|
        class_works.create!(org_class: org_class)
      end
      return true
    rescue
      return false
    end
  end
end
