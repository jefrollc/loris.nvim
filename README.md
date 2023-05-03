# Loris

Dead simple autorunner inspired by the good folks at [Do(n't) use this
c<>de](https://www.dontusethiscode.com/)

### Usage

Navigate to a Tmux pane and run the shell script `runner.sh`. This uses
`inotifywait` to watch a file.

In Neovim from any file add a code block the way you would on github or in markdown using: 

\`\`\`language
<code>
\`\`\`

With your cursor in the code block call `require('loris').parse_block()`. This
will write the block to the file and `runner.sh` should run it.  

### Todo:

Need to test more languages. Currently have only tested zsh, python, and zig.
