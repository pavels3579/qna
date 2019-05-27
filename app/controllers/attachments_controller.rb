class AttachmentsController < ApplicationController
  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    return head :forbidden unless current_user.its_author?(@attachment.record)

    @attachment.purge
    @attachment
  end

end
