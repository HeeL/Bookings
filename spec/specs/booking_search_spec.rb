require File.dirname(__FILE__) + '/../spec_helper.rb'

describe BookingSearch do

  before(:all) do
    dir = File.dirname(__FILE__) + '/../data/'
    @search = BookingSearch.new(dir + "acc.json", dir + "tr.json")
    @search.find_match
  end

  describe "#find_accommodation" do
    it "found more than one traveller in the accommodation" do
      @search.find_accommodation(1).should == {tr: "Mrs. Tess Goyette\nIzabella Fay", acc: "Simonis Campsite"}
    end

    it "found no traveller in the accommodation" do
      @search.find_accommodation(3).should == {tr: '', acc: ''}
    end

    it "found one traveller in the accommodation" do
      @search.find_accommodation(4).should == {tr: "Keaton Kuvalis", acc: "McKenzie Campsite2"}
    end
  end

  describe "#find_traveller" do
    it "found a traveller with an accommodation" do
      @search.find_traveller(2).should == {tr_name: "Izabella Fay", acc_name: "Simonis Campsite"}
    end

    it "found a traveller without an accommodation" do
      @search.find_traveller(1).should == {tr_name: "Mrs. Everardo Pacocha", acc_name: ""}
    end

    it "looks for a traveller with a wrong id" do
        @search.find_traveller(99999999999).should be_nil
    end
  end

  describe "#search_accommodation" do
    it "found the accommodation with the price between min and max" do
      options = [{'priceRange' => {'min' => 80, 'max' => 300}, 'requirements' => ['bath']}]
      (80..300).should include(@search.search_accommodation(options)[:acc][:price])
    end

    it "looks for accommodation with non existent requirements" do
      options = [{'priceRange' => {'min' => 80, 'max' => 300}, 'requirements' => ['stripteasers']}]
      @search.search_accommodation(options).should == {:tr=>{:id=>"", :name=>""}}
    end

    it 'looks for accommodation with the price that too low' do
      options = [{'priceRange' => {'min' => 1, 'max' => 3}, 'requirements' => ['gym']}]
      @search.search_accommodation(options).should == {:tr=>{:id=>"", :name=>""}}
    end
  end

end