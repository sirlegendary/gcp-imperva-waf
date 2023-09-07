#!/usr/bin/env bash

sudo useradd wale \
   --shell /bin/bash \
   --create-home 
echo 'wale:Imperva' | sudo chpasswd
sudo sed -ie 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

sudo service sshd reload


echo "Adding wale user to sudoers"
sudo tee /etc/sudoers.d/wale > /dev/null <<"EOF"
wale ALL=(ALL:ALL) ALL
EOF
sudo chmod 0440 /etc/sudoers.d/wale
sudo usermod -a -G sudo wale

# gcloud compute images export \
#     --destination-uri gs://imperva-image-2023/imperva-test-image.tar.gz \
#     --image imperva-test-image \
#     --export-format vmdk \
#     --project gl-compliance-governance


