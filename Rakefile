require 'nanoc3/tasks'
require 'fileutils'

namespace :create do
  desc "Creates a new page in the content root"
  task :page do
    require 'active_support/core_ext'
    if !ENV['title']
      $stderr.puts "\t[error] Missing title argument.\n\tusage: rake create:page title='page title'"
      exit 1
    end
    
    title = ENV['title'].capitalize
    full_path = "content/" + title.parameterize('-') + ".html"

    template = <<TEMPLATE
---
title: "#{title.titleize}"
---

TODO: Add content to `#{full_path}.`
TEMPLATE

    File.open(full_path, 'w') { |f| f.write(template) }
    $stdout.puts "\t[ok] Edit #{full_path}"
  end

  desc "Creates a new article"
  task :article do
    require 'active_support/core_ext'
    require 'active_support/multibyte'
    @ymd = Time.now.to_s(:db).split(' ')[0]
    if !ENV['title']
      $stderr.puts "\t[error] Missing title argument.\n\tusage: rake create:article title='article title'"
      exit 1
    end

    title = ENV['title'].capitalize
    path, filename, full_path = calc_path(title)

    if File.exists?(full_path)
      $stderr.puts "\t[error] Exists #{full_path}"
      exit 1
    end

    template = <<TEMPLATE
---
created_at: #{@ymd}
excerpt:
kind: article
publish: true
tags: [misc]
title: "#{title.titleize}"
---

TODO: Add content to `#{full_path}.`
TEMPLATE

    FileUtils.mkdir_p(path) if !File.exists?(path)
    File.open(full_path, 'w') { |f| f.write(template) }
    $stdout.puts "\t[ok] Edit #{full_path}"
  end

  def calc_path(title)
    ymd = @ymd.split('-')
    year, month, day = ymd[0], ymd[1], ymd[2]
    path = "content/" + year + "/" + month + "/" + day + "/"
    filename = title.parameterize('-') + ".erb.html"
    [path, filename, path + filename]
  end
end

