## 0.1.2

  - Modified the FormHelper so that view helper method is named `s3_cors_fileupload_form_tag` (instead of `s3_cors_fileupload_form`) to maintain consistency with the rest of ActionView's view helpers.
  - Improving usage documentation on the README to provide a more detailed explanation of what the gem provides.

## 0.1.1

  - Fixed generator so that the [SourceFile model](https://github.com/fullbridge-batkins/s3_cors_fileupload/blob/master/lib/generators/s3_cors_fileupload/install/templates/source_file.rb) requires the aws-s3 gem properly.