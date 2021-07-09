#!/usr/bin/env ruby

# frozen_string_literal: true

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)
ENV['DUMP_PATH'] ||= File.expand_path('..', __dir__)

require 'rubygems'
require 'bundler'
Bundler.require(:default)

require_relative '../lib/vc_reader'

VcReader.run
