# S3CorsFileupload

A gem to allow for uploading of files to directly AWS-S3 via [CORS](http://www.w3.org/TR/cors/) using the
[jQuery-File-Upload javascript](http://blueimp.github.com/jQuery-File-Upload/) for Rails 3.1 and greater.

## Installation
Add this line to your application's Gemfile:

    gem 's3_cors_fileupload'

Then run `bundle install`.

Next run the install generator, which creates a config file, then generates (but does not run)
a migration to add a source_files table and a corresponding model, as well as a controller, routes,
and views for the file uploading.

    bundle exec rails generate s3_cors_fileupload:install

If you are using HAML as the template language for your app, the install generator has an option to produce
HAML view files (the default is ERB):

    bundle exec rails g s3_cors_fileupload:install --template-language=haml

If you don't want to generate a migration (for instance if you've already run the install generator in the past),
you can pass in `--skip-migration` like so:

    bundle exec rails g s3_cors_fileupload:install --skip-migration

If you chose to generate a migration, run it now:

    bundle exec rake db:migrate

Also, as you may have noticed, a config file was generated at `config/amazon_s3.yml`.  Edit this file and fill in
the fields with your AWS S3 credentials.  If you don't want to commit your S3 account credentials to your
repository, you can make the config file load from environment variables like so (this functionality is fixed as of version `0.1.5`):

    secret_access_key: <%= ENV['S3_SECRET_ACCESS_KEY'] %>

Add the following javascript and CSS to your asset pipeline:

**s3_cors_fileupload.js**
```javascript
//= require s3_cors_fileupload
```

**jquery.fileupload-ui.css**
```css
*= require jquery.fileupload-ui
```

Now before you're ready to run the application, make sure your AWS S3 CORS settings for your bucket are setup
to receive file uploads.  Before you put the application into production, I would highly recommend reading
[the official documentation for CORS](http://docs.amazonwebservices.com/AmazonS3/latest/dev/cors.html).
If you just want to get up and running, here is a configuration that will get you going:

```
<CORSConfiguration>
    <CORSRule>
        <AllowedOrigin>http://localhost:3000</AllowedOrigin>
        <AllowedMethod>GET</AllowedMethod>
        <AllowedMethod>POST</AllowedMethod>
        <AllowedMethod>PUT</AllowedMethod>
        <MaxAgeSeconds>3000</MaxAgeSeconds>
        <AllowedHeader>*</AllowedHeader>
    </CORSRule>
</CORSConfiguration>
```

If you use this CORS Config, and you start to see warnings like
"Origin http://localhost:3000 is not allowed by Access-Control-Allow-Origin", then you can modify the `AllowedOrigin`
line like so:

    <AllowedOrigin>*</AllowedOrigin>

Just be sure to change this value to your server's domain before you put it into production, otherwise anybody
can upload to your bucket from any domain.

## Usage

Run your rails server

    bundle exec rails server

Then navigate to `http://<server_root>/source_files` to get started.  The files that `s3_cors_fileupload`'s install generator
provide you with are just a guide to get you started.  I thought this would be helpful for others since it took me a while to
get the [jQuery-File-Upload javascript](http://blueimp.github.com/jQuery-File-Upload/) uploading directly to S3.  I encourage
you to modify the controller, source files, and javascript as you see fit!

### What the gem provides for your Rails app

S3CorsFileupload will inject the javascripts and CSS (with the exception of [Twitter Bootstrap](http://twitter.github.com/bootstrap/))
styling necessary to render the UI version of the [jQuery-File-Upload javascript](http://blueimp.github.com/jQuery-File-Upload/)
into the asset pipeline of your Rails application.  For more details on how Twitter Bootstrap is leveraged, see
[the Notes section below](#notes).  

The gem also provides a view helper to your Rails app, `s3_cors_fileupload_form_tag`, which will produce a form that renders
the UI version of the [jQuery-File-Upload javascript](http://blueimp.github.com/jQuery-File-Upload/) when called.
This view helper accepts the following options:

* `:access_key_id` - The AWS Access Key ID of the owner of the bucket.  Defaults to the `Config.access_key_id` (read from the `config/amazon_s3.yml` config file).
* `:acl` - One of S3's Canned Access Control Lists, must be one of: `'private'`, `'public-read'`, `'public-read-write'`, `'authenticated-read'`.  Defaults to `'public-read'`.
* `:max_file_size` - The max file size (in bytes) that you wish to allow to be uploaded.  Defaults to `Config.max_file_size` (read from the `config/amazon_s3.yml` config file) or, if no value is set on the `config/amazon_s3.yml` file, defaults to `524288000` (500 MB)
* `:bucket` - The name of the bucket on S3 you wish for the files to be uploaded to.  Defaults to `Config.bucket` (read from the `config/amazon_s3.yml` config file).
* Any other key creates standard HTML options for the form tag.

For an example of how to use the form view helper, see the file located at `app/views/s3_uploads/index.html.erb` that
the install generator produces.

## Notes

The UI version of the [jQuery-File-Upload javascript](http://blueimp.github.com/jQuery-File-Upload/)
javascript uses aspects of the [Twitter Bootstrap](http://twitter.github.com/bootstrap/) CSS for styling purposes.
In the view file created at `s3_uploads/index.html.erb` by this gem's install generator, a copy of the Bootstrap CSS hosted on
[BootstrapCDN](http://www.bootstrapcdn.com/) is included via a `stylesheet_link_tag`. If you plan to use bootstrap in more
places throughout your application, you may want look into using a gem such as
[twitter-bootstrap-rails](https://github.com/seyhunak/twitter-bootstrap-rails), which allows you to inject
the stylesheets and javascripts from bootstrap into the asset pipeline.

I have made a slight modification to the jQuery-File-Upload-UI so that the destroy button accepts an optional `data-confirmation`
attribute, which in turn causes it to show a confirmation dialog to the user before the destroy action happens.  This functionality
mimics that of Rails's built in [jquery-ujs behavior for `data-confirm`](https://github.com/rails/jquery-ujs/wiki/Unobtrusive-scripting-support-for-jQuery)
attributes on forms (I named this one `data-confirmation` to prevent jquery-ujs from conflicts).
The code for this was based off of [pull request #1127 to the jQuery-File-Upload project](https://github.com/blueimp/jQuery-File-Upload/pull/1127),
which appears to have been rejected by the author of jQuery-File-Upload, but seems appropriate for rails.  If you wish not to use it,
simply remove the `data-confirmation` attribute from the destroy button on `_template_uploaded.html.erb` in the views directory.

## Contributing to S3CorsFileupload
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Please try to add tests. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.
* Make a pull request.

Note: I am still in the process of trying to write a more thorough test suite, so any specs people want to contribute would be very welcome!

## Copyright

Copyright (c) 2012 Ben Atkins. See [LICENSE.txt](https://github.com/fullbridge-batkins/s3_cors_fileupload/blob/master/LICENSE.txt)
for further details.
