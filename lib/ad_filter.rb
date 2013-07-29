class AdFilter
  FILTER_ATTRIBUTES = [:region_id, :category_id, :ad_type]

  attr_accessor :region_id, :category_id, :ad_type, :query, :page, :per_page

  def initialize(params = {})
    params ||= {}
    params.each do |key, value|
      if((value.instance_of?(Symbol) || value.instance_of?(String)) && self.respond_to?(key))        
        value = value.present? && value.to_i != 0 ? value.to_i : nil unless key.to_sym == :query
        value = nil if value.blank?
        instance_variable_set("@#{key}", value) unless value.nil?
      end
    end
  end

  def search_without(skip_attribute)
    search(FILTER_ATTRIBUTES.reject{ |attr| attr == skip_attribute })
  end
  
  def search(filter_attributes = FILTER_ATTRIBUTES)
    Sunspot.search(Ad) do
      fulltext(query)
      filter_attributes.each { |attr| with(attr, self.send(attr)) if self.send(attr) }
      FILTER_ATTRIBUTES.each { |attr| facet(attr) }
      with(:status, Ad.status[:active])
      paginate(page: page || 1, per_page: per_page || Ad::PER_PAGE)
      order_by(:created_at, :desc) if query.blank?
    end
  end
end
