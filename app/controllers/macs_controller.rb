class MacsController < ApplicationController
  def index
    if current_user.admin?
      @macs = Mac.all
    else
      @macs = current_user.macs
    end
  end
end
