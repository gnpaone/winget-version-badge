# Winget Version Badge

[![Releases](https://img.shields.io/github/v/release/gnpaone/winget-version-badge?style=flat-square)](https://github.com/gnpaone/winget-version-badge/releases)
[![Build](https://img.shields.io/github/actions/workflow/status/gnpaone/winget-version-badge/build.yml?style=flat-square&logo=github)](https://github.com/gnpaone/winget-version-badge/actions/workflows/build.yml)
[![LICENSE](https://img.shields.io/github/license/gnpaone/winget-version-badge?style=flat-square)](https://github.com/gnpaone/winget-version-badge/blob/main/LICENSE)
[![Vercel](https://vercelbadge.vercel.app/api/gnpaone/winget-version-badge?style=flat-square&logo=vercel)](https://winget-version-badge.vercel.app)
[![Issues](https://img.shields.io/github/issues/gnpaone/winget-version-badge?color=orange&style=flat-square)](https://github.com/gnpaone/winget-version-badge/issues)

#### Get your own latest version number badge for your Winget package

<hr noshade>

## Introduction

An unofficial shields.io badge with package version fetched from custom API.

## API Query Parameters
<table>
  <thead>
    <tr>
      <th>Workflow parameter</th>
      <th>API Parameter</th>
      <th>Default value</th>
      <th>Description</th>
      <th>Required</th>
      <th>Possible values</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>id</td>
      <td>id</td>
      <td><em>null</em></td>
      <td>Package id - can be found using <code>winget search</code></td>
      <td>Yes</td>
      <td><em>Winget package identifier (ID)</em></td>
      <td rowspan="9">All these parameters (related to workflow only) supports updating multiple package badges at a time without calling the workflow multiple times.<br><a href="https://github.com/gnpaone/winget-version-badge/blob/main/.github/workflows/example.yml">Example workflow</td>
    </tr>
    <tr>
      <td>style</td>
      <td>style</td>
      <td>flat</td>
      <td>Style of the badge</td>
      <td>No</td>
      <td>flat, flat-square, plastic, for-the-badge, plastic, social</td>
    </tr>
    <tr>
      <td>label</td>
      <td>label</td>
      <td>Winget package</td>
      <td>Override the default left-hand-side text</td>
      <td>No</td>
      <td><em>Text (special chars included)</em></td>
    </tr>
    <tr>
      <td>label_color</td>
      <td>labelColor</td>
      <td>gray</td>
      <td>Background color of the left part</td>
      <td>No</td>
      <td><em>hex, rgb, rgba, hsl, hsla and css named colors supported</em></td>
    </tr>
    <tr>
      <td>color</td>
      <td>color</td>
      <td>blue</td>
      <td>Background color of the right part</td>
      <td>No</td>
      <td><em>hex, rgb, rgba, hsl, hsla and css named colors supported</em></td>
    </tr>
    <tr>
      <td><em>N/A</em></td>
      <td>image</td>
      <td>false</td>
      <td>Return version as shields.io badge oor just as plain text</td>
      <td>No</td>
      <td>true <em>or</em> 1, false</td>
    </tr>
    <tr>
      <td>readme_path</td>
      <td><em>N/A</em></td>
      <td>./README.md</td>
      <td>Path of the markdown file</td>
      <td>No</td>
      <td><em>File path relative to the root directory of the GitHub repo</em></td>
    </tr>
    <tr>
      <td>marker_text</td>
      <td><em>N/A</em></td>
      <td><em>null</em></td>
      <td>Start and end markers to identify and update the badge</td>
      <td>Yes</td>
      <td><em>Marker text</em></td>
    </tr>
    <tr>
      <td>pkg_link</td>
      <td><em>N/A</em></td>
      <td><em>null</em></td>
      <td>Package or repo link</td>
      <td>No</td>
      <td><em>URL of the package repo</em></td>
    </tr>
  </tbody>
</table>

#### Notes for the workflow:
* Make sure to change the following in your GitHub repo settings: `Actions` > `General` > `Workflow permissions` > Choose `Read and write permissions` > Check `Allow GitHub Actions to create and approve pull requests` > `Save`.
* Other parameters `commit_user`, `commit_email`, `commit_message` related to action workflow are optional.
* For fetching multiple package versions
  * `id` and `marker_text` must contain equal number of elements.
  * Other parameters can either be single element which applies to all the multiple badges or number of elements must be equal to `id` and `marker_text`.
  * The multiple elements should be comma separated and overall wrapped in double quotes.
  * Empty elements are allowed for `style` and `label_color` parameters only.
* The README markdown file must contain start marker `<!-- EXAMPLE_MARKER_START -->` and end marker `<!-- EXAMPLE_MARKER_END -->` where "EXAMPLE_MARKER" is the input of `marker_text` parameter. Note that the `_START` and `_END` part is important.
* The fetched versions can be accessed via `outputs.winget_ver` for further usage in the workflow. If multiple versions are fetched then this contains versions separated with ",".

## Usage
API calling example: `https://winget-version-badge.vercel.app/?id=Git.Git&image=true`<br>
Workflow examples: [Basic workflow](https://github.com/gnpaone/winget-version-badge/blob/main/examples/basic.yml) | [Multi versions](https://github.com/gnpaone/winget-version-badge/blob/main/examples/multi-ver.yml) <br>
<!-- EXAMPLE_1_START -->
[![GitHub.cli](https://img.shields.io/badge/Winget%20package-2.9.0-blue?style=plastic&labelColor=)](https://github.com)<!-- EXAMPLE_1_END --><!-- EXAMPLE_2_START -->
[![Git.Git](https://img.shields.io/badge/Winget%20package-2.46.0-green?style=plastic&labelColor=red)](https://github.com)<!-- EXAMPLE_2_END -->

## Limitations
- Since deployed in Vercel, all its limitations applied. Thus it is requested not to abuse the API usage and push it to limits.
- Run the github actions only either after your own package published or using workflow dispatch. It is not recommended to run as scheduled workflow (`cron`) due to vercel rate limits.
- Github README happens to have a timeout of around 10s but API takes more than 10s to fetch the version thus it's advised to use the github actions workflow as required instead of using API link directly.

## License
This project is licensed under BSD-3-Clause.  
Copyright (c) 2024, Naveen Prashanth. All Rights Reserved.
