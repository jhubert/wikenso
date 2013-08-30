# encoding: utf-8

class WikiLogoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process :resize_to_fit => [100, 60]

  def store_dir
    "uploads/#{model.subdomain.downcase}/logo"
  end

  def default_url
     "/images/default_logo.png"
  end

  def extension_white_list
     %w(jpg jpeg png)
  end
end
