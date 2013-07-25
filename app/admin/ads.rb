# encoding: UTF-8

ActiveAdmin.register Ad do

  index do
    column :title, :sortable => :title do |article|
      link_to article.title, edit_admin_ad_path(article)
    end
    column :category, :sortable => :category_id
    column :city, :sortable => :category_id
    column :created_at, :sortable => :created_at
    default_actions
  end

  form do |f|

    f.inputs "Content" do
      f.input :title
      f.input :category
      f.input :city, collection: City.order(:name)
      f.input :phone
      f.input :email
      f.input :ad_type, as: :select, collection: Ad.type
      f.input :status, as: :select, collection: Ad::STATES
      f.input :description
      f.input :user
    end

    f.inputs "Image" do
      f.input :image, :as => :file
    end
    f.buttons
  end

  controller do
    def show
      redirect_to :admin_ads
    end
  end

end
