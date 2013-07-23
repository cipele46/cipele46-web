class AdFilter
  attr_accessor :region_id, :category_id, :ad_type, :query

  def initialize(params = {})
    params ||= {}
    params.each do |key, value|
      value = value.present? && value.to_i != 0 ? value.to_i : nil unless key.to_sym == :query
      value = nil if value.blank?
      instance_variable_set("@#{key}", value) unless value.nil?
    end
  end

  def clone_without(skip_attribute)
    new_filter = AdFilter.new
    [:region_id, :category_id, :ad_type, :query].each do |method|
      new_filter.send(method.to_s + '=', skip_attribute == method ? nil : self.send(method))
    end
    new_filter
  end
end
