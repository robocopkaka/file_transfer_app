class DocumentsController < ApplicationController
  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)
    if @document.save
      flash[:success] = 'Document uploaded successfully'
      redirect_to documents_path
    else
      render 'new'
    end
  end

  def index
    @documents = Document.all
  end

  def show
    @document = Document.find_by(id: params[:id])
  end

  def download
    @document = Document.find_by(id: params[:id])
    # binding.pry
    @length = 0
    @progress = 0
    tempfile = Down.download @document.file.service_url,
      content_length_proc: -> (content_length) do
        @length = content_length
        # ActionCable.server.broadcast 'download_progress_channel', length: content_length
      end,
      progress_proc: -> (progress) do
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
end
