App.download_progress = App.cable.subscriptions.create "DownloadProgressChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    @showProgressBar(data)

  showProgressBar: (data) ->
    doc = $("#document-#{data.id}")
    progressBarDiv = doc.find('#show-progress')
    cover = progressBarDiv.find('.progress-bar-cover')
    progressBar = progressBarDiv.find('.progress-bar')
    cover.show()
    downloadProgress = parseInt(data.progress/data.length * 100, 10)
    progressBar.css('width', downloadProgress + '%').text(downloadProgress + '%')

    if data.progress == data.length
      setTimeout ->
        progressBarDiv.hide()
      , 1500

