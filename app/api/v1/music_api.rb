module V1
  class MusicApi < Grape::API
    resources :musics do
      params do
        optional :music_type_id, type: Integer, desc:"音乐类型id"
      end
      desc "获取music,如果没有带music_type_id,则取所有音乐"
      get do
        music_type_id = params[:music_type_id]
        if music_type_id.nil?
          musics = Music.all
        else
          musics = Music.where(music_type_id: music_type_id)
        end
        if musics.size == 0
          error!("没有找到任何记录", 404)
        else
          present musics, with: ::Entities::Music
        end
      end
    end

    resources :music_types do
      desc "获取所有音乐类型"
      get do
        music_types = MusicType.all
        present music_types, with: ::Entities::MusicType
      end
    end
  end
end
