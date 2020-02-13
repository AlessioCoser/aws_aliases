function setup_aws_credentials() {
    profile_name=$1
    current_user="$USER"
    role_arn=`/usr/bin/grep -A4 "$profile_name\]" ~/.aws/credentials|/usr/bin/grep role_arn|sed 's/^.*arn:/arn:/g'`

    if [[ -z "$role_arn" ]]
    then
        role_arn=`/usr/bin/grep -A4 "$profile_name\]" ~/.aws/config|/usr/bin/grep role_arn|sed 's/^.*arn:/arn:/g'`
    fi

    local stscredentials
    stscredentials=$(aws sts assume-role \
        --profile $profile_name \
        --role-arn "${role_arn}" \
        --role-session-name $current_user \
        --query '[Credentials.SessionToken,Credentials.AccessKeyId,Credentials.SecretAccessKey]' \
        --output text)

    AWS_ACCESS_KEY_ID=$(echo "${stscredentials}" | awk '{print $2}')
    AWS_SECRET_ACCESS_KEY=$(echo "${stscredentials}" | awk '{print $3}')
    AWS_SESSION_TOKEN=$(echo "${stscredentials}" | awk '{print $1}')
    AWS_SECURITY_TOKEN=$(echo "${stscredentials}" | awk '{print $1}')

    region=$(/usr/bin/grep -A4 "\[$profile_name\]" ~/.aws/credentials|/usr/bin/grep region|sed s/'.*=[ ]'//g)
    if [ $region ]
    then
        AWS_DEFAULT_REGION=$region
        export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_SECURITY_TOKEN AWS_DEFAULT_REGION
    else
        export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_SECURITY_TOKEN
    fi

    echo "Default AWS region set to '$region'"
    echo "AWS env variables set:"
    printenv | grep AWS | sed 's;=.*;;' | sort
}

function git-aws () {
  security delete-internet-password -l "git-codecommit.eu-west-1.amazonaws.com" > /dev/null 2>&1
  git config --global credential.UseHttpPath true >/dev/null 2>&1
  git config --global credential.helper '!aws codecommit credential-helper --profile '$1'' > /dev/null 2>&1
  git ${@:2}
  git config --global --unset credential.UseHttpPath > /dev/null 2>&1
  git config --global --unset credential.helper > /dev/null 2>&1
}