terraform {
  backend "gcs" {
    bucket = "my-bucket-gcs-tfstate"
    prefix = "vpn"
  }
}
