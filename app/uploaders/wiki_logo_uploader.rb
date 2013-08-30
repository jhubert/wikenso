# encoding: utf-8

class WikiLogoUploader < CarrierWave::Uploader::Base
  def store_dir
    "uploads/#{model.subdomain.downcase}/logo"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  def extension_white_list
     %w(jpg jpeg png)
  end
end
