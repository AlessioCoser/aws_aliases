# ZSH AWS Aliases
Antigen bundle to ass aws aliases to your zsh shell

## Prerequisites
- [Zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
- [Antigen](https://github.com/zsh-users/antigen)
- [aws-cli](https://www.code2bits.com/how-to-install-awscli-on-macos-using-homebrew/)

## Install
Add these lines to your `.zshrc`:

```
source /usr/local/share/antigen/antigen.zsh

antigen bundle AlessioCoser/zsh_aws_aliases
antigen apply
```

## Aliases

### setup_aws_credentials
It's used to set aws credentials on your shell environment including temporary access token (also used with MFA authentications)

```
$ setup_aws_credentials [YOUR_AWS_PROFILE]
```

### git-aws
It's a wrapper around git command. It overrides the default git credentials helper to use the AWS IAM specific credentials only for that command.

```
$ git-aws [AWS_PROFILE] [[GIT_COMMANDS] ...]
```