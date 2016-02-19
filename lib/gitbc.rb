require 'httparty'
require 'colorize'
require 'octokit'

require 'optparse'
require 'ostruct'
require 'json'
require 'yaml'
require 'open3'

class GitHubBasecampExtractor
  DEFAULT_CONFIG_FILE = File.expand_path('~/.gitbc')
  DEFAULT_END_TAG = 'HEAD'

  def initialize(params)
    @params = params
    @github_client = Octokit::Client.new(access_token: @params[:github_access_token])
  end

  def get_pull_requests_from_git_logs
    lines = `git --no-pager log #{@params[:branch]} #{@params[:start_tag]}..#{@params[:end_tag]} --merges | grep 'Merge pull request #'`.split("\n")
    lines.map {|l| l[/.*#([0-9]+)/,1].to_i}
  end

  def is_git_installed?
    begin
      Open3.popen3('git --version')
      return true
    rescue Errno::ENOENT
      return false
    end
  end

  def is_git_repo?
    Open3.popen3('git status') { |_, _, stderr, _| stderr.read } !~ /Not a git repository/
  end

  def git_branch
    Open3.popen3('git status') { |_, stdout, _, _| stdout.read }[/^On branch ([^\n]+)/,1]
  end

  def git_branch_exists?(branch)
    Open3.popen3('git branch') { |_, stdout, _, _| stdout.read } =~ /#{branch}/
  end

  def git_repository
    Open3.popen3('git remote -v') { |_, stdout, _, _| stdout.read }[/git@github.com:(.+).git/,1]
  end

  def repo_exists?(repo)
    @github_client.repository?(repo)
  end

  def remote_matches?(repo)
    Open3.popen3('git remote -v') { |_, stdout, _, _| stdout.read } =~ /#{repo}/
  end

  def revision_exists?(rev)
    Open3.popen3("git cat-file -t #{rev}") { |_, stdout, _, _| stdout.read } =~ /commit/
  end

  def is_github_alive?
    begin
      raise if @github_client.github_status_last_message.attrs[:status] != 'good'
    rescue
      return false
    end
    return true
  end

  def update_options(options)
    @params.merge(options)
  end

  def get_basecamp_todos(pull_requests)
    basecamp_todos = pull_requests.inject({}) do |memo, pull_request_id|
      pr = @github_client.pull_request(@params[:repository], pull_request_id)
      basecamp_lines = pr.attrs[:body].split("\r\n").grep(/.*https\:\/\/basecamp\.com.*/)
      if basecamp_lines.count > 0
        memo[pull_request_id] = basecamp_lines.map { |line| {url: line[/.*(https\:\/\/basecamp\.com[^!?#:;,.\s]*)/, 1]} }.uniq
        if @params[:basecamp_content]
          memo[pull_request_id].each do |line|
            line[:url].match /(https\:\/\/basecamp\.com\/\d+\/)(.*)/ do |match|
              begin
                ret = HTTParty.get "#{match[1]}api/v1/#{match[2]}.json", {basic_auth: {username: @params[:basecamp_user], password: @params[:basecamp_password]}, headers: {'Content-Type' => 'application/json', 'User-Agent' => "gitbc API (#{@params[:basecamp_user]})"}}
                line[:content] = JSON.parse(ret.body)['content'] if ret != nil && ret.body.length > 0
              rescue
              end
            end
          end
        end
      end
      memo[pull_request_id] ||= []
      yield(pull_request_id, memo[pull_request_id])
      memo
    end
    basecamp_todos
  end
end
