class AvatarUploader < CarrierWave::Uploader::Base
  # アップロードファイルの保存場所を`public/`配下 or S3に指定
  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  # アップロードファイルの保存するディレクトリを指定
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # デフォルトで表示する画像を指定(`app/assets/images`に保存した画像が使える)
  def default_url
    'avatar.png'
  end

  # アップロードを許可するファイルの拡張子を指定
  def extension_allowlist
    %w[jpg jpeg png gif]
  end
end
