## 0.1.5

  - Added option to select 'haml' as the language template for the view files on the install generator.
  - Fixed `S3CorsFileupload::Config` YAML initializer so that it properly reads in ERB statements.

## 0.1.4

  - Added a `data-confirmation` option to the delete buttons and functionality to the jQuery-File-Upload UI's destroy callback that picks up the contents of that attribute to use as a confirmation dialog.  (Fixed the implementation from v0.1.3)  [See the README notes for more details](https://github.com/fullbridge-batkins/s3_cors_fileupload#notes).

## 0.1.3 (Yanked)
  
  - Improving install generator so that generation of the migration file is optional.
  - Removed some unnecessary code on some of the generator templates.
  
## 0.1.2

  - Modified the FormHelper so that view helper method is named `s3_cors_fileupload_form_tag` (instead of `s3_cors_fileupload_form`) to maintain consistency with the rest of ActionView's view helpers.
  - Improving usage documentation on the README to provide a more detailed explanation of what the gem provides.

## 0.1.1

  - Fixed generator so that the [SourceFile model](https://github.com/fullbridge-batkins/s3_cors_fileupload/blob/master/lib/generators/s3_cors_fileupload/install/templates/source_file.rb) requires the aws-s3 gem properly.