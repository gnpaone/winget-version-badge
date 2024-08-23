# frozen_string_literal: true

require 'net/http'
require 'erb'
require 'open-uri'

class Winget
  def run
    id             = ENV['INPUT_ID']
    style          = ENV['INPUT_STYLE']
    label          = ENV['INPUT_LABEL'] || 'Winget package'
    labelColor     = ENV['INPUT_LABEL_COLOR']
    color          = ENV['INPUT_COLOR']
    readme_path    = ENV['INPUT_README_PATH']
    marker_text    = ENV['INPUT_MARKER_TEXT']
    pkg_link       = ENV['INPUT_PKG_LINK']
    newline        = ENV['INPUT_NEWLINE']
    html           = ENV['INPUT_HTML']
    git_username   = ENV['INPUT_COMMIT_USER']
    git_email      = ENV['INPUT_COMMIT_EMAIL']
    commit_message = ENV['INPUT_COMMIT_MESSAGE'] || 'Update README.md'

    fetch_winget(id, style, label, labelColor, color, marker_text, pkg_link, newline, html, readme_path, commit_message, git_username, git_email)
  rescue StandardError => e
    puts "Error: #{e.message}"
    exit 1
  end

  private

  def fetch_winget(id, style, label, labelColor, color, marker_text, pkg_link, newline, html, readme_path, commit_message, git_username, git_email)
    id_array = id.split(';', -1)
    marker_text_array = marker_text.split(';', -1)

    if id_array.length != marker_text_array.length
      puts "Error: 'id' and 'marker_text' must have the same array length."
      exit 1
    end

    def handle_param_array(param, id_length, param_name)
      param_array = param.split(';', -1)
      if param_array.length == 1
        Array.new(id_length, param_array[0])
      elsif param_array.length == id_length
        param_array
      else
        puts "Error: '#{param_name}' must have an array length of 1 or equal to 'id' array length."
        exit 1
      end
    end

    style_array = handle_param_array(style, id_array.length, 'style')
    label_array = handle_param_array(label, id_array.length, 'label')
    labelColor_array = handle_param_array(labelColor, id_array.length, 'labelColor')
    color_array = handle_param_array(color, id_array.length, 'color')
    readme_path_array = handle_param_array(readme_path, id_array.length, 'readme_path')
    pkg_link_array = handle_param_array(pkg_link, id_array.length, 'pkg_link')
    newline_array = handle_param_array(newline, id_array.length, 'newline')
    html_array = handle_param_array(html, id_array.length, 'html')

    winget_ver_array = Array.new(id_array.length)

    id_array.length.times do |i|
      api_url = "https://winget-version-badge.vercel.app/?id=#{id_array[i]}"
      uri = URI(api_url)
      req = Net::HTTP::Get.new(uri)

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end

      if response.is_a?(Net::HTTPSuccess)
        pkg_ver = URI.open(api_url).read
        winget_ver_array[i] = pkg_ver

        update_readme_content(id_array[i], style_array[i], label_array[i], labelColor_array[i], color_array[i], marker_text_array[i], pkg_link_array[i], newline_array[i], html_array[i], readme_path_array[i], pkg_ver)
      else
        puts "Failed to retrieve: #{id_array[i]} - #{response.code} - #{response.message}"
        exit 1
      end
    end

    winget_ver = winget_ver_array.join(';')

    File.open(ENV['GITHUB_OUTPUT'], 'a') do |file|
      file.puts("winget_ver=#{winget_ver}")
    end

    update_git_repo(readme_path, commit_message, git_username, git_email)
  end

  def update_readme_content(id, style, label, labelColor, color, marker_text, pkg_link, newline, html, readme_path, winget_ver)
    readme_content = File.read(readme_path)
    start_marker = "<!-- #{marker_text}_START -->"
    end_marker = "<!-- #{marker_text}_END -->"
    shields_url = "https://img.shields.io/badge/#{ERB::Util.url_encode(label)}-#{winget_ver}-#{ERB::Util.url_encode(color)}?style=#{style}&labelColor=#{ERB::Util.url_encode(labelColor)}"

    if html=="true"
      updated_readme_content = readme_content.gsub(/#{start_marker}.*#{end_marker}/m, "#{start_marker}<a href='#{pkg_link}'><img src='#{shields_url}' alt='#{id}' /></a>#{end_marker}")
    elsif html=="false"
      if newline=="true"
        updated_readme_content = readme_content.gsub(/#{start_marker}.*#{end_marker}/m, "#{start_marker}\n[![#{id}](#{shields_url})](#{pkg_link})#{end_marker}")
      elsif newline=="false"
        updated_readme_content = readme_content.gsub(/#{start_marker}.*#{end_marker}/m, "#{start_marker}[![#{id}](#{shields_url})](#{pkg_link})#{end_marker}")
      end
    end

    File.write(readme_path, updated_readme_content)
  end

  def update_git_repo(readme_path, commit_message, git_username, git_email)
    `git config --global --add safe.directory /github/workspace`
    `git config user.name #{git_username}`
    `git config user.email #{git_email}`

    status = `git status`
    unless status.include?("nothing to commit")
      `git add #{readme_path}`
      `git commit -m "#{commit_message}"`
      `git push`
    end
  end
end

Winget.new.run