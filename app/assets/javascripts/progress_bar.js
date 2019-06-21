$(document).on('turbolinks:load', function () {
  const documentForm = $('.upload-document');
  documentForm.fileupload({dataType: 'script'});

  const cover = documentForm.find('.progress-bar-cover');

  const progressBar = cover.find('.progress-bar');

  documentForm.on('fileuploadstart', function() {
    cover.show();
  });

  documentForm.on('fileuploadprogressall', function (e, data) {
    const progress = parseInt(data.loaded/data.total * 100, 10)
    progressBar.css('width', progress + '%').text(progress + '%')
  });
});