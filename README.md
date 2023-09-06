# gcp-imperva-waf

# create image from running VM
`gcloud compute images create imperva-test-image --project=gl-compliance-governance --source-disk=imperva --source-disk-zone=europe-west1-b --storage-location=eu --force`

`gcloud compute images export \
    --destination-uri gs://imperva-image-2023/my-image.tar.gz \
    --image https://www.googleapis.com/compute/v1/projects/imperva-cloud-images-public/global/images/securesphere-waf-14-4-0-16-0-39028-europe \
    --export-format vmdk`


# https://developer.hashicorp.com/packer/integrations/hashicorp/googlecompute/latest/components/post-processor/googlecompute-export