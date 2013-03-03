class HacksController < ApplicationController

  def index
  end

  def create
    hack = Hack.new(params[:url])

    if hack.url_valid?
      if hack.drop_mah_payload!
        flash.now[:notice] = "Aw right, done."
      else
        flash.now[:error] =  "Sorry can't do."
      end
    else
      flash.now[:error] =  "Invalid url..."
    end

    render :index
  end

end
