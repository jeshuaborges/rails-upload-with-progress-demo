# Browser upload to S3 or other file storage system

This project demonstrates a way to separate the uploading of a file from the client to a server from the processing of a file. Given that Heroku doesn't support XHR2 this becomes a pretty common problem. Additionally you need to test locally without hitting external systems so there is a mechanism to use a local upload store if you desire.

How to support:

* XHR2 for upload with progress
* Cross-Origin Resource Sharing (CORS)
* Flexible document stores via Fog
* Testing

TODO:

* Add S3 signing
* More client side examples

[![Build Status](https://secure.travis-ci.org/jeshuaborges/rails-upload-with-progress-demo.png?branch=master)](https://travis-ci.org/jeshuaborges/rails-upload-with-progress-demo)
