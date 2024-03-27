#!/bin/bash
PASSWORD=''

FIELD_NAME='password'
VALUE_TO_ENCRYPT=''
VALUE_TO_DECRYPT=''

echo $PASSWORD > ansiblepass

# ENCRYPTION
ansible-vault encrypt_string "$VALUE_TO_ENCRYPT" \
--name "$FIELD_NAME" \
--vault-password-file ansiblepass

# DECRYPTION
# echo "$VALUE_TO_DECRYPT" | tr -d ' ' | ansible-vault decrypt \
# --vault-password-file ansiblepass

rm ansiblepass
