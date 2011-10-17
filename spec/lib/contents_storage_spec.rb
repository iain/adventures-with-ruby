require 'contents_storage'

describe ContentsStorage do

  let(:path) { "/tmp" }
  let(:id)   { "article-name" }

  subject { ContentsStorage.new(id, path) }

  after do
    File.unlink(subject.filename) if File.exist?(subject.filename)
  end

  describe "#filename" do

    it "is a yaml filename based on path and id of article" do
      subject.filename.should == "/tmp/article-name.yml"
    end

  end

  describe "#read" do

    before do
      File.open(subject.filename, 'w:utf-8') { |file| file.write "--- \nfoo: bar\n" }
    end

    it "reads the file" do
      subject.read.should == { "foo" => "bar" }
    end

    it "is memoized" do
      YAML.should_receive(:load_file).once.and_return({})
      2.times { subject.read }
    end

  end

  describe "#write" do

    it "writes content to file" do
      subject.write("foo" => "bar")
      File.open(subject.filename, 'r:utf-8').read.should == "--- \nfoo: bar\n"
    end

  end

end
