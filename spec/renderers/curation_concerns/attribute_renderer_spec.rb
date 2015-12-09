require 'spec_helper'

describe CurationConcerns::AttributeRenderer do
  let(:field) { :name }
  let(:renderer) { described_class.new(field, ['Bob', 'Jessica']) }
  let(:yml_path) { File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'locales', '*.{rb,yml}') }
  before do
    I18n.load_path += Dir[File.join(yml_path)]
    I18n.reload!
  end
  after do
    I18n.load_path -= Dir[File.join(yml_path)]
    I18n.reload!
  end
  describe "#attribute_to_html" do
    subject { Nokogiri::HTML(renderer.render) }
    let(:expected) { Nokogiri::HTML(tr_content) }
    context 'without microdata enabled' do
      before do
        CurationConcerns.config.display_microdata = false
      end
      let(:tr_content) {
        "<tr><th>Name</th>\n" \
         "<td><ul class='tabular'><li class=\"attribute name\"><span>Bob</span></li>\n" \
         "<li class=\"attribute name\"><span>Jessica</span></li>\n" \
         "</ul></td></tr>"
      }
      it { expect(renderer).not_to be_microdata(field) }
      it { expect(subject).to be_equivalent_to(expected) }
    end
    context 'with microdata enabled' do
      before do
        CurationConcerns.config.display_microdata = true
      end
      let(:tr_content) {
        "<tr><th>Name</th>\n" \
         "<td><ul class='tabular'><li class=\"attribute name\" itemscope itemtype=\"http://schema.org/Person\" itemprop=\"name\">" \
         "<span itemprop=\"firstName\">Bob</span></li>\n" \
         "<li class=\"attribute name\" itemscope itemtype=\"http://schema.org/Person\" itemprop=\"name\">" \
         "<span itemprop=\"firstName\">Jessica</span></li>\n" \
         "</ul></td></tr>"
      }
      it { expect(renderer).to be_microdata(field) }
      it { expect(subject).to be_equivalent_to(expected) }
    end
  end
end