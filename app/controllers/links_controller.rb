class LinksController < ApplicationController

  def destroy
    @link = Link.find(params[:id])
    link_parent = @link.linkable

    return head :forbidden unless current_user.its_author?(link_parent)

    @link.destroy
    @link
  end

end
