# frozen_string_literal: true

# Documents controller
class DocumentsController < ApplicationController
  before_action :authenticate_user!, only: %i[show]
  before_action :find_document, only: %i[download]
  def new
    @document = Document.new
  end

  def create
    @document = current_user.documents.build(document_params)
    if @document.save
      flash[:success] = 'Document uploaded successfully'
      redirect_to documents_path
    else
      render 'new'
    end
  end

  def index
    @documents = current_user.documents.with_attached_file
  end

  def show
    @document = current_user.documents.with_attached_file.find_by(id: params[:id])
  end

  def download
    @length = 0
    @progress = 0
    path = '/Users/andeladeveloper/workspace/rails_test_projects/file_transfer_app/public/images/'
    file_name = @document.file.service_url.scan(/%22(.*?)%22/).join
    if File.exist?("#{path}/#{file_name}")
      @message = 'File downloaded before'
      respond_to do |format|
        format.js
      end
    else
      download_doc
    end
  end

  private

  def document_params
    params.require(:document).permit(:name, :file)
  end

  def find_document
    @document = Document.with_attached_file.find_by(id: params[:id])
  end

  def download_doc
    tempfile = Down.download @document.file.service_url,
                             content_length_proc: ->(content_length) do
                               @length = content_length
                             end,
                             progress_proc: ->(progress) do
                               broadcast_download(progress)
                             end
    path = '/Users/andeladeveloper/workspace/rails_test_projects/file_transfer_app/public/images/'
    FileUtils.mv(tempfile.path, "#{path}#{tempfile.original_filename}")
  end

  def broadcast_download(progress)
    ActionCable.server.broadcast 'download_progress_channel',
                                 progress: progress,
                                 length: @length,
                                 id: @document.id
  end
end
