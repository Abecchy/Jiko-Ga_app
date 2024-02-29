class PostImageUploader < CarrierWave::Uploader::Base
  # アップロードファイルの保存場所を`public/`配下に指定
  storage :file

  # アップロードファイルの保存するディレクトリを指定
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # デフォルトで表示する画像を指定(`app/assets/images`に保存した画像が使える)
  def default_url
    'post_image.jpeg'
  end

  # アップロードを許可するファイルの拡張子を指定
  def extension_allowlist
    %w[jpg jpeg png gif]
  end
end
