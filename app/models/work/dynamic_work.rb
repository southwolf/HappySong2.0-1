# 创作作业 -> materials 素材
class DynamicWork < HomeWork

  # associations
  has_many :materials, as: :materialable , class_name: 'Material'

  # methods
  def build_dynamic_work(qiniu_files, class_ids)
    begin
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
