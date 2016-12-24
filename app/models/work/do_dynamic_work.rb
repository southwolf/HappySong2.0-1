# 少年说 | 创作作业都在这里 -> 关联了 student_work_id 就是创作作业
class DoDynamicWork < DoWork

end

# 写作业
# 1: 创作作业 -> {
#   has_many -> 素材集
#   content
#   地理坐标
#   student_work_id
# }
#
# 2: 朗读作业 -> {
#   朗读记录 -> 素材集
#   student_work_id
# }
