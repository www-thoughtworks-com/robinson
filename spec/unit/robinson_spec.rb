require 'rspec'
require_relative '../../lib/robinson'

describe Robinson do

  let(:page) {double('Anemone::Page', links: nil, url: nil)}
  let(:host) {'showcase.thoughtworks.com'}
  let(:links_on_page) {[URI("http://#{host}/not-on-website"), URI("https://#{host}/on-website")]}

  it 'returns relevant links on page' do
    allow(page).to receive(:links).and_return(links_on_page)
    allow(page).to receive(:url).and_return("https://#{host}/")

    relevant_links = Robinson.get_relevant_links_on_page(host, [], page)

    expect(relevant_links.first.to_s).to eq "https://#{host}/on-website"
  end
end