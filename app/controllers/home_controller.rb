class HomeController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def get_entry
		@entries = Entry.all



		render :entry
	end

  def post_entry
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

end
