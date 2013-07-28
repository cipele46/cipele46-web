describe AdFilter do
  subject { AdFilter.new(params) }
  
  describe '#new' do
    context 'with region set' do
      let(:params) { { region_id: '11' } }
      its(:region_id) { should == 11 }
    end

    context 'with category set' do
      let(:params) { { category_id: '1' } }
      its(:category_id) { should == 1 }
    end

    context 'with type set' do
      let(:params) { { ad_type: '2' } }
      its(:ad_type) { should == 2 }
    end

    context 'with query set' do
      let(:params) { { query: 'something' } }
      its(:query) { should == 'something' }
    end
  end

  let(:filter_options) do
    { 
      ad_type: '1', 
      region_id: '10', 
      category_id: '4',
      query: 'some search',
      page: '2',
      per_page: '10'
    }
  end

  describe '#search_without' do
    it 'should do a search without the specified attribute' do
      filter = AdFilter.new(filter_options)
      filter.stub(:search)
      filter.should_receive(:search).with([:category_id, :ad_type])
      filter.search_without(:region_id)    
    end
  end

  describe '#search', sunspot_matchers: true do
    before do 
      AdFilter.new(filter_options).search
    end
    it 'should search for Ads' do
      Sunspot.session.should be_a_search_for(Ad)
    end

    it 'should do a fulltext search on query' do
      Sunspot.session.should have_search_params(:fulltext, 'some search')
    end

    it 'should facet by category' do
      Sunspot.session.should have_search_params(:facet, :category_id)
    end

    it 'should facet by type' do
      Sunspot.session.should have_search_params(:facet, :ad_type)
    end

    it 'should facet by region' do
      Sunspot.session.should have_search_params(:facet, :region_id)
    end
    
    it 'should filter by region' do
      Sunspot.session.should have_search_params(:with, :region_id, 10)
    end
    
    it 'should filter by type' do
      Sunspot.session.should have_search_params(:with, :ad_type, 1)
    end
    
    it 'should filter by category' do
      Sunspot.session.should have_search_params(:with, :category_id, 4)
    end

    it 'should paginate' do
      Sunspot.session.should have_search_params(:paginate, page: 2, per_page: 10)
    end

    it 'should order results by rank (default)' do
      Sunspot.session.should_not have_search_params(:order_by, any_param)
    end

    context 'with attributes specified' do
      before { AdFilter.new(filter_options).search([:category_id]) }

      it 'should not filter by region' do
        Sunspot.session.should_not have_search_params(:with, :region_id, any_param)
      end
      
      it 'should not filter by type' do
        Sunspot.session.should_not have_search_params(:with, :ad_type, any_param)
      end

      it 'should filter by category' do
        Sunspot.session.should have_search_params(:with, :category_id, 4)
      end
    end

    context 'with no pagination params specified' do
      before do 
        AdFilter.new(filter_options.reject{ |key| key =~ /^(page|per_page)$/ }).search
      end

      it 'should use the default values' do
        Sunspot.session.should have_search_params(:paginate, page: 1, per_page: Ad::PER_PAGE)
      end
    end

    context 'with no query specified' do
      before do 
        AdFilter.new(filter_options.reject{ |key| key == :query }).search
      end
      
      it 'should order results by creation date' do
        Sunspot.session.should have_search_params(:order_by, :created_at, :desc)
      end
    end
  end
end
