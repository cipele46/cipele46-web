collection @regions
attributes :name, :id
child :cities, :object_root => false do
  attributes :id, :name
end
