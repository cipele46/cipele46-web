ActiveAdmin.register Blog do

  index do
    column :title, :sortable => :title do |article|
      link_to article.title, edit_admin_ad_path(article)
    end
    column :created_at, :sortable => :created_at
    default_actions
  end

  form do |f|

    f.inputs "Content" do
      f.input :title
      f.input :content
    end

    f.inputs "Image" do
      f.input :image, :as => :file
    end
    f.buttons
  end

  controller do
    def show
      redirect_to :admin_blogs
    end
  end

end
