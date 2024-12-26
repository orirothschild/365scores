terraform {
  backend "s3" {
    bucket         = "home-assignment-ori"
    key            = "terraform/state"
    region         = "eu-north-1"

  }
}
