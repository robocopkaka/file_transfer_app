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
    @documents = current_user.documents
  end

  def show
    @document = current_user.documents.find_by(id: params[:id])
  end

  def download
    @length = 0
    @progress = 0
    tempfile = Down.download @document.file.service_url,
      content_length_proc: ->(content_length) do
        @length = content_length
      end,
      progress_proc: ->(progress) do
        ActionCable.server.broadcast 'download_progress_channel',
                                     progress: progress,
                                     length: @length,
                                     id: @document.id
      end
  end

  private

  def document_params
    params.require(:document).permit(:name, :file)
  end

  def find_document
    @document = Document.find_by(id: params[:id])
  end
end
