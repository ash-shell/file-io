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

   FLAGS
          -e, --expires 'time'  (default: 2 weeks) positive integer followed by
                                    w (week), m (month) or y (year)

EXAMPLES
          ash fileio --expires 1w help.txt license.md
          ash fileio help.txt license.md -e 1w
          ash fileio --expires 1w help.txt license.md -e 1y readme.md

NOTES
          The expires/e flag is able to be added after or before the files.
          Which ever you pattern you choose you must be consitant with.

```

## License
[MIT](license.md)
