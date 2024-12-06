#!/usr/bin/env ruby
# frozen_string_literal: true

require './config/application'

require 'securerandom'

uuid = SecureRandom.uuid

Utils::JsonRequest.call(
  url: "http://entrance-application:9292/entrance-application/user/#{uuid}",
  payload: nil,
  http_method: :get
)

Utils::JsonRequest.call(
  url: "http://entrance-application:9292/entrance-application/validate-user-license/#{uuid}",
  payload: nil,
  http_method: :post
)
