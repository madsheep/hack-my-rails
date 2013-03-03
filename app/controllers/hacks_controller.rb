class HacksController < ApplicationController

  def index
  end

  def create
    hack = Hack.new(params[:url])
    binding.pry
    if hack.url_valid?
      if hack.drop_mah_payload!
        flash.now[:notice] = "Aw right, done."
      else
        flash.now[:error] =  "Sorry can't do that. They've got it easy."
      end
    else
      flash.now[:error] =  "Invalid url..."
    end

    render :index
  end

end
