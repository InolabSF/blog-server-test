class Photo < ApplicationRecord
  # def self.create_photos_by(photo_params)
  #
  # # /* そもそも一枚も上がってきてない時のためのvalidate */
  #   return false if photo_params[:content].nil?
  #
  # # /* 途中でエラった時にRollbackするようにTransaction */
  #   Photo.transaction do
  #
  # # /* アップロードされた画像を一枚ずつ処理 */
  #     photo_params[:content].each do |photo|
  #       new_photo = Photo.new(title: photo_params[:title], content: photo)
  #       return false unless new_photo.save!
  #     end
  #   end
  #
  #   true
  # end
end
