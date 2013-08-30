# encoding: utf-8

class WikiLogoUploader < CarrierWave::Uploader::Base
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
