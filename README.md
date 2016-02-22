# Gitbc

Gitbc is a tool that extracts information from GitHub pull requests and combines it with related Basecamp to-dos. It might come handy if you're using Basecamp to-dos for tracking progress of your tasks. To make such tracking work, each time you create a pull request you need to copy to-do's URL into its body (which is probably something you're doing already).

Gitbc does its magic by running git CLI locally on the developer's machine. There is git instructed to pick up all merge commits from some given start tag (if end tag was omitted, HEAD will be used). Pull requests' numbers are extracted from those commits (PR numbers are embedded into merge commits automatically by GitHub) and content of each pull request is retrieved using GitHub API. If the body of pull request contains a Basecamp's to-do URL, its title is fetched via Basecamp API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gitbc', git: 'https://github.com/okulik/gitbc.git'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install specific_install && gem specific_install https://github.com/okulik/gitbc.git

## Usage

The only required parameter is start tag. All other parameters, such as branch and git repository names, will be automatically inferred by gitbc. Here are all available CLI parameters:

```bash
Usage: git-bc <start_tag> [end_tag] [options]
    -f, --config-file FILE           Use specific configurations file (default is ~/.gitbc)
    -a, --github-token TOKEN         Use specific GitHub access token
    -u, --basecamp-user USER         Use specific Basecamp user
    -p, --basecamp-password PASSWORD Use specific Basecamp password
    -b, --branch BRANCH              Use specific git branch
    -r, --repository REPO            Query specific GitHub repository
    -q, --quiet                      Quiet tool output
    -c, --basecamp-content           Include content of the related Basecamp TODO
    -h, --help                       Show this message
```

GitHub and Basecamp credentials can be provided using CLI parameters or by creating a configuration file (default one used is ~/.gitbc).

Configuration file requires three items:

*  github\_access\_token - a personal [GitHub access token](https://help.github.com/articles/creating-an-access-token-for-command-line-use), use full private repo access
* basecamp\_user - Basecamp account's user name
* basecamp\_password - Basecamp account's password

Here's an example how .gitbc should look like

```
github_access_token: abcdefghabcdefghabcdefghabcdefghabcdefgh
basecamp_user: orest@nisdom.com
basecamp_password: 123456789012345678901234567890
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/okulik/gitbc.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

