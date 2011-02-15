require "rubygems"
#require "HTTParty"
require "net/http"
require "uri"
require "ruby-debug"
require 'net/http/post/multipart'
    
class Document
  #include HTTParty
  @base_uri = "http://localhost:8983/solr"
  
  def self.index(id, filename)
    puts "\nINDEXING #{id}, #{filename}\n"
    puts "==========="

    url = URI.parse("#{@base_uri}/update/extract")
    File.open(filename) do |file|
      uploaded_file = UploadIO.new(file, "", filename)
      req = Net::HTTP::Post::Multipart.new url.path,
        "myfile" => UploadIO.new(file, "", filename), "literal.id" => id, "commit" => true
      res = Net::HTTP.start(url.host, url.port) do |http|
        http.request(req)
      end
      puts res
    end


    # uri = URI.parse("#{@base_uri}/update/extract")
    # file = File.read(filename)
    # #options = { :id => id, "commit" => true, :text => file}
    # options = { :id => id, "commit" => true, :myfile => filename}
    # #res = Document.post('/update/extract', :body => options)
    # response = Net::HTTP.post_form(uri, options)
    # puts response
  end
  
  def self.search(q)
    puts "\nSEARCHING\n"
    #res = Document.get('/select?indent=on&q=cucumber&wt=json')
    uri = URI.parse("#{@base_uri}/select?indent=on&q=#{q}&wt=json")
    response = Net::HTTP.get_response(uri)
    puts response
  end
  
  def self.delete(id)
    options = {:delete => {:id => id}}
    res = Document.post('/update/extract', :body => options)
  end
end

Document.index("doc1#{rand 1000}", "rspecbook.pdf")
#Document.index("doc2#{rand 1000}", "iPad intro.pdf")
Document.index("doc3#{rand 1000}", "test.docx")
Document.index("doc4#{rand 1000}", "test.txt")
Document.search "dropbox"