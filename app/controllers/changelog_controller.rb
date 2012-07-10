class ChangelogController < ApplicationController

  def index
    @log = `git log --pretty=format:"%ae|%an|%h|%ar|%s" -n 20`
    @log = @log.scan(/(.+)\|(.+)\|(.+)\|(.+)\|(.+)/).map do |(e,n,h,t,m)| 
      next if m =~ /Merge|github/
      {
        email: e,
        name: n,
        hash: h,
        time: t,
        message: m
      }
    end
    @log.compact!

  end

end
