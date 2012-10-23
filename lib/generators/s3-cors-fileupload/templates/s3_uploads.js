/*
 * s3-cors-file-upload
 * http://github.com/fullbridge-batkins/s3-cors-fileupload
 *
 * Copyright 2012, Ben Atkins
 * https://batkins.net
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/MIT
 */

// This global variable will hold s3 file credentials for files until it's time to submit them
var s3_upload_hash = {};

$(function() {
  // hit the controller for info when the file comes in
  $('#fileupload').bind('fileuploadadd', function (e, data) {
      var content_type = data.files[0].type;
      var file_name = data.files[0].name;
     $.ajax({
        url: '/source_files/generate_key',
        type: 'GET',
        dataType: 'json',
        data: {filename: file_name}, // send the file name to the server so it can generate the key param
        async: false,
        success: function(data) {
          // Now that we have our data, we add it to the global s3_upload_hash so that it can be
          // accessed (in the fileuploadsubmit callback) prior to being submitted
          s3_upload_hash[file_name] = {
                                        key: data.key,
                                        content_type: content_type
                                      };
        }
      })
    });
  
  // this gets triggered right before a file is about to be sent (and have their form action submitted)
  $('#fileupload').bind('fileuploadsubmit', function (e, data) {
      var file_name = data.files[0].name;
      // transfer the data from the upload-template .form hidden fields to the real form's hidden fields
      var form = $('#fileupload');
      form.find('input[name=key]').val(s3_upload_hash[file_name]['key']);
      //form.find('input[name=policy]').val(s3_upload_hash[file_name]['policy']);
      //form.find('input[name=signature]').val(s3_upload_hash[file_name]['signature']);
      form.find('input[name=Content-Type]').val(s3_upload_hash[file_name]['content_type']);
      // lastly remove it from the global s3_upload_hash (Garbage Collection)
      delete s3_upload_hash[file_name];
  });
   
  $('#fileupload').bind('fileuploaddone', function (e, data) {
    // the response will be XML, and can be accessed by calling `data.result`
    //
    // Here is an example of what the XML will look like coming back from S3:
    //  <PostResponse>
    //    <Location>https://fullbridge-development.s3.amazonaws.com/cma%2F3ducks.jpg</Location>
    //    <Bucket>fullbridge-development</Bucket>
    //    <Key>cma/3ducks.jpg</Key>
    //    <ETag>"c4301ef289687822f34f92b65afda320"</ETag>
    //  </PostResponse>
     
     $.post('/source_files',
          {
            'file[url]': $(data.result).find('Location').text(),
            'file[bucket]': $(data.result).find('Bucket').text(),
            'file[key]': $(data.result).find('Key').text(),
            authenticity_token: $('meta[name=csrf-token]').attr('content')
          },
          function(data) {
            $('#upload_files tbody').append(tmpl('template-uploaded', data));
          },
          'json'
      );
   });
   
   // remove the table row containing the source file information from the page
   $('#fileupload').bind('fileuploaddestroyed', function (e, data) {
      var deleted_object_id = data.url.split('/').pop();
      // now remove the element from the page
      $('#source_file_' + deleted_object_id).remove();
   });
 
});

// this is used by the jQuery-File-Upload
var fileUploadErrors = {
  maxFileSize: 'File is too big',
  minFileSize: 'File is too small',
  acceptFileTypes: 'Filetype not allowed',
  maxNumberOfFiles: 'Max number of files exceeded',
  uploadedBytes: 'Uploaded bytes exceed file size',
  emptyResult: 'Empty file upload result'
};

function formatFileSize(bytes) {
    if (typeof bytes !== 'number') {
        return '';
    }
    if (bytes >= 1000000000) {
        return (bytes / 1000000000).toFixed(2) + ' GB';
    }
    if (bytes >= 1000000) {
        return (bytes / 1000000).toFixed(2) + ' MB';
    }
    return (bytes / 1000).toFixed(2) + ' KB';
}
