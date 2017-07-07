class HomeController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def get_entry
		@entries = Entry.all

		render :entry
	end

  def form_entry
    @entries = Entry.all

    render :form
  end

  def display_entry
    @entries = Entry.all

    render :board
  end

  def post_entry_by_url
    title = params[:title]
    # content = params[:content]
    image = params[:image]

    entry = Entry.new
    entry.title = title
    entry.image = image


    ##########################################
    # jsonの作成
    ##########################################

    featuretype = 'TEXT_DETECTION'

    json_file_path = 'gcv_request_body.json'

    file = File.open(json_file_path)
    hash = JSON.load(file)
    # pp hash
    json_str = JSON.dump(hash)
    # pp json_str

    json_str.gsub!(/URL/, image)
    json_str.gsub!(/TYPE/, featuretype)

    ##########################################
    # faradayコネクションの作成
    ##########################################

    # gcl Vision api url
    # apiUrl = "vision.googleapis.com/v1/images:annotate"
    apiUrl = "vision.googleapis.com"
    uri = "https://" + apiUrl

    conn = Faraday::Connection.new(:url => uri) do |builder|
     ## URLをエンコードする
      builder.use Faraday::Request::UrlEncoded
     ## ログを標準出力に出したい時(本番はコメントアウトでいいかも)
      builder.use Faraday::Response::Logger
     ## アダプター選択（選択肢は他にもあり）
      builder.use Faraday::Adapter::NetHttp

    end

    ##########################################
    # faradayからpostリクエスト
    ##########################################

    #gcp apiKey
    apiKey = "AIzaSyApbivNJfHiy6tW-X2JPZmtseUwfm6D99c"
    requrl = "/v1/images:annotate" + "?key=" + apiKey

    res = conn.post do |req|
       req.url requrl
       req.headers['Content-Type'] = 'application/json'
       req.body = json_str
    end

    body = JSON.parse(res.body)
    entry.content = body["responses"][0]["textAnnotations"][0]["description"]

    if entry.valid?
      entry.save
      render json: { :message => 'post succeeded' }, status: 200
    else
      render json: { :message => 'post failed' }, status: 400
    end
  end

  ##########################################

  # ファイルアップローダー

  ##########################################

  def post_entry_by_file
    title = params[:title]
    # content = params[:content]
    file = params[:file]

    ##########################################
    # fileをbase64に変換
    ##########################################

    readimage = Base64.strict_encode64(file.read)

    # ##########################################
    # # fileをローカルに保存
    # ##########################################
    #
    # image = save_image(title, file)

    ##########################################
    # entryモデルの作成
    ##########################################

    entry = Entry.new
    entry.title = title
    # entry.image = image
    entry.imagedata = readimage


    ##########################################
    # jsonの作成
    ##########################################

    featuretype = 'TEXT_DETECTION'

    json_file_path = 'gcv_request_body_base64.json'

    file = File.open(json_file_path)
    hash = JSON.load(file)
    # pp hash
    json_str = JSON.dump(hash)
    # pp json_str

    json_str.gsub!(/CONTENT/, readimage)
    json_str.gsub!(/TYPE/, featuretype)

    ##########################################
    # faradayコネクションの作成
    ##########################################

    # gcl Vision api url
    # apiUrl = "vision.googleapis.com/v1/images:annotate"
    apiUrl = "vision.googleapis.com"
    uri = "https://" + apiUrl

    conn = Faraday::Connection.new(:url => uri) do |builder|
     ## URLをエンコードする
      builder.use Faraday::Request::UrlEncoded
     ## ログを標準出力に出したい時(本番はコメントアウトでいいかも)
      builder.use Faraday::Response::Logger
     ## アダプター選択（選択肢は他にもあり）
      builder.use Faraday::Adapter::NetHttp

    end

    ##########################################
    # faradayからpostリクエスト
    ##########################################

    #gcp apiKey
    apiKey = "AIzaSyApbivNJfHiy6tW-X2JPZmtseUwfm6D99c"
    requrl = "/v1/images:annotate" + "?key=" + apiKey

    res = conn.post do |req|
       req.url requrl
       req.headers['Content-Type'] = 'application/json'
       req.body = json_str
    end

    body = JSON.parse(res.body)
    entry.content = body["responses"][0]["textAnnotations"][0]["description"]

    if entry.valid?
      entry.save
      render json: { :message => 'post succeeded' }, status: 200
    else
      render json: { :message => 'post failed' }, status: 400
    end

  end

  def save_image(title, imagefile)
  # ready filepath
  fileName = title + '.jpg'
  dirName = "/Users/Kazuya/Documents/Work/Bootcamp/Server/board/image/"
  filePath = dirName + fileName

  # create folder if not exist
  FileUtils.mkdir_p(dirName) unless FileTest.exist?(dirName)

  # write image adata
    open(filePath, 'wb') do |output|
      output.write(imagefile)
    end
    return fileName
  end

end
