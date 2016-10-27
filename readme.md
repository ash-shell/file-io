# fileio
> Upload file(s) to https://file.io

## Installation
You're going to have to install [Ash](https://github.com/ash-shell/ash) to use this module.

After you have Ash installed, run either one of these two commands depending on your git clone preference:

- `ash apm:install git@github.com:ash-shell/file-io.git --global`
- `ash apm:install https://github.com/ash-shell/file-io.git --global`

## Usage
```bash
$ ash fileio:help
fileio(1)

NAME
          fileio - Upload file(s) to https://file.io

SYNOPSIS
          fileio file             upload single file & copy link to clipboard
          fileio file1 file2      upload multiple files
          fileio:history          output history

```

## License
[MIT](license.md)
