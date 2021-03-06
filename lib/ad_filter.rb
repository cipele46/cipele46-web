class AdFilter
  FILTER_ATTRIBUTES = [:region_id, :category_id, :ad_type, :user_id]

  SEARCH_ATTRIBUTES = [:region_id, :category_id, :ad_type, :query, :page, :per_page, :user_id] 

  SEARCH_ATTRIBUTES.each {|attr| attr_accessor attr }

  def initialize(params = {})
    if params.symbolize_keys.keys.any? {|key| SEARCH_ATTRIBUTES.include? key}
      normalized_hash_of(params).each do |key, value|
        set_attribute key, to: value 
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

  private

    def normalized_hash_of(hash)
      Helpers::NormalizedHash.new(hash).normalize
    end

    def set_attribute(name, opts = {})
      send("#{name}=", opts[:to]) if self.respond_to?(name) 
    end
end

module Helpers
  class NormalizedValue
    NOT_NUMERIC = [:query, :user]

    def initialize(original, key)
      self.value = original
      self.key = key.to_sym
    end

    def normalize
      case 
      when NOT_NUMERIC.include?(key)
        value
      when present?
        value.to_i
      end
    end

    private

    def present?
      !blank?
    end

    def blank?
      value.blank? || value.to_i == 0
    rescue
      false
    end

    attr_accessor :value, :key
  end

  class NormalizedHash

    def initialize(original_hash)
      self.hash = original_hash
    end

    def normalize
      result = {}

      hash.each do |key, value|
        result[key] = NormalizedValue.new(value, key).normalize
      end

      result
    end

    private

    attr_accessor :hash
  end
end
