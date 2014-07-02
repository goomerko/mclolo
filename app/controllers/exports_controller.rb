class ExportsController < ApplicationController
  layout false
  def macs
    @macs = Mac.includes({user: :nodes}).where("nodes_users.node_id in (?)", current_user.nodes.map(&:id)).where('macs.blocked = false AND users.blocked = false').references(:nodes_users)

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
