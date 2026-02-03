class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy 
  
  validates :title, presence: true
  validates :body, presence: true

  validates :youtube_url,
            format: {
              with: /\A(https?:\/\/)?(www\.)?(youtube\.com\/watch\?v=|youtu\.be\/)[\w-]+/,
              message: 'はYouTubeのURLを入力してください'
            },
            allow_blank: true 
  
  def youtube_video_id
    return nil if youtube_url.blank?

    # パターン1: https://youtu.be/dZ2dcC4OnQE
    if youtube_url.include?('youtu.be/')
      youtube_url.split('youtu.be/').last.split('?').first
    # パターン2: https://www.youtube.com/watch?v=dZ2dcC4OnQE
    elsif youtube_url.include?('watch?v=')
      youtube_url.split('watch?v=').last.split('&').first
    end
  end
end
