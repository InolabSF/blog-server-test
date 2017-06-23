class HomeController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def get_entry
		@entries = Entry.all

		render :entry
	end

  def post_entry
    title = params[:title]
    content = params[:content]

    entry = Entry.new
    entry.title = title
    entry.content = content

    if entry.valid?
      entry.save
      render json: { :message => 'post succeeded' }, status: 200
    else
      render json: { :message => 'post failed' }, status: 400
    end
  end

end
