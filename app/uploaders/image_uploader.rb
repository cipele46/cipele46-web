# -*- encoding : utf-8 -*-
class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  include Sprockets::Helpers::IsolatedHelper
  include Sprockets::Helpers::RailsHelper

  storage :file

  def default_url
     ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_')) 
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    asset_path("images")
  end

  version :large do
    resize_to_fit(800, 600)
  end

  version :mob_large do
    resize_to_fit(580, 435)
  end

  version :medium do
    resize_to_fit(500, 375)
  end

  version :small do
    resize_to_fit(260, 195)
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
