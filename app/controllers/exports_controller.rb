class ExportsController < ApplicationController
  layout false
  def macs
    @macs = Mac.where(blocked:false)

    text = @macs.collect { |m| "#{m.mac} ##{m.comment}" }.join("\n")
    text << "\n"

    current_user.ping_timestamp = DateTime.now
    current_user.save

    respond_to do |format|
      format.txt do
        render :text => text
      end

      format.iptables do
        @header = current_user.header
        @footer = current_user.footer

        render :template => 'exports/iptables.html.erb'
      end
    end
  end
end
