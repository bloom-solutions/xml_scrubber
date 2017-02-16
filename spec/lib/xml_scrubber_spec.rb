require "spec_helper"

describe XMLScrubber do
  it "has a version number" do
    expect(XMLScrubber::VERSION).not_to be nil
  end

  describe ".call" do
    context "scrubbing name matched by regex" do
      let(:dirty_xml) do
        <<-XML
        <xml xmlns:x="http://schemas.xmlsoap.org/soap/envelope/">
          <x:username>uname</x:username>
          <x:paSSword>sekret</x:paSSword>
        </xml>
        XML
      end
      subject(:resulting_xml) do
        XMLScrubber.(dirty_xml, {name: {matches: /password/i}})
      end
      subject(:resulting_tree) { Nokogiri.XML(resulting_xml) }

      it "scrubs all matching nodes by name" do
        expect(resulting_tree.xpath("//x:username").text).to eq "uname"
        expect(resulting_tree.xpath("//x:paSSword").text).to eq "[filtered]"
      end
    end

    context "scrubbing name matched by string but no match" do
      let(:dirty_xml) do
        <<-XML
        <xml xmlns:x="http://schemas.xmlsoap.org/soap/envelope/">
          <x:username>uname</x:username>
          <x:paSSword>sekret</x:paSSword>
          <username>uname-no-ns</username>
        </xml>
        XML
      end
      subject(:resulting_xml) do
        XMLScrubber.(
          dirty_xml,
          {name: {matches: "x:password"}},
          {name: {matches: "x:username"}},
        )
      end
      subject(:resulting_tree) { Nokogiri.XML(resulting_xml) }

      it "scrubs all matching nodes by name" do
        expect(resulting_tree.xpath("//x:username").text).
          to eq described_class::DEFAULT_REPLACEMENT
        expect(resulting_tree.xpath("//x:paSSword").text).to eq "sekret"
        expect(resulting_tree.xpath("//username").text).to eq "uname-no-ns"
      end
    end

    context "given an array of directives" do
      let(:dirty_xml) do
        <<-XML
        <xml xmlns:x="http://schemas.xmlsoap.org/soap/envelope/">
          <x:username>uname</x:username>
          <x:paSSword>sekret</x:paSSword>
          <username>uname-no-ns</username>
        </xml>
        XML
      end
      subject(:resulting_xml) do
        XMLScrubber.(
          dirty_xml,
          [
            {name: {matches: "x:password"}},
            {name: {matches: "x:username"}},
          ]
        )
      end
      subject(:resulting_tree) { Nokogiri.XML(resulting_xml) }

      it "scrubs all matching nodes by name" do
        expect(resulting_tree.xpath("//x:username").text).
          to eq described_class::DEFAULT_REPLACEMENT
        expect(resulting_tree.xpath("//x:paSSword").text).to eq "sekret"
        expect(resulting_tree.xpath("//username").text).to eq "uname-no-ns"
      end
    end

    context "given an unknown directive" do
      it "raises an error" do
        expect {
          XMLScrubber.("<xml/>", unknown: {matches: "x:password"})
        }.to raise_error(ArgumentError, "unknown directive `unknown`")
      end
    end
  end

end
