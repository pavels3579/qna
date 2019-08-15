class LinksController < ApplicationController

  def destroy
    @link = Link.find(params[:id])
    link_parent = @link.linkable

    authorize! :destroy, link_parent

    @link.destroy
    @link
  end

end
