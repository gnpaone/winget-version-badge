# Winget Version Badge

[![LICENSE](https://img.shields.io/github/license/gnpaone/winget-version-badge)](https://github.com/gnpaone/winget-version-badge/blob/main/LICENSE)
[![Vercel](https://vercelbadge.vercel.app/api/gnpaone/winget-version-badge)](https://winget-version-badge.vercel.app)

Get your own latest version number badge for your Winget package

## Introduction

An unofficial shields.io badge with package version fetched from custom api.

## Limitations
- Since deployed in Vercel, all its limitations applied.

## Query Parameters
| Parameter | Default value | Description | Required | Possible values |
|:---------:|:-------------:|:-----------:|:--------:|:---------------:|
| id | _null_ | Package id - can be found using `winget search` | Yes | _Winget package identifier (ID)_ |
| style | flat | Style of the badge | No | flat, flat-square, plastic, for-the-badge, social |
| label | Winget package |  Override the default left-hand-side text | No | _Text (special chars included)_ |
| labelColor | gray | Background color of the left part | No | _hex, rgb, rgba, hsl, hsla and css named colors supported_ |
| color | blue | Background color of the right part | No | _hex, rgb, rgba, hsl, hsla and css named colors supported_ |

## Usage
API calling example: `https://winget-version-badge.vercel.app/?id=Git.Git`
![Default](https://winget-version-badge.vercel.app/?id=Git.Git)
![Custom Label](https://winget-version-badge.vercel.app/?id=Git.Git&label=Git.Git&color=red&labelColor=green)

## License
This project is licensed under BSD-3-Clause.  
Copyright (c) 2024, Naveen Prashanth. All Rights Reserved.
