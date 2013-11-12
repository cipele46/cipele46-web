object @ad
attributes :id, :title, :description, :status, :ad_type, :phone, :email
child :city, :object_root => false do
  attributes :id, :name
end
child :category, :object_root => false do
  attributes :id, :name
end
child :user, :object_root => false do
  attributes :id
end
