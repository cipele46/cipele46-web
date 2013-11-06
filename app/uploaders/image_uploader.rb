# -*- encoding : utf-8 -*-
class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
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
