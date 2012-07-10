class ChangelogController < ApplicationController

  def index
    @log = `git log --pretty=format:"%h|%an|%ar|%s" -n 20`
    @log = @log.split("\n")
    @log = @log.select { |e| e !~ /Merge|github/ }


  end

end
