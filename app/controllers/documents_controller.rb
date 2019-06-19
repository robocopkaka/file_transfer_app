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

  private

  def document_params
    params.require(:document).permit(:name, :file)
  end
end
