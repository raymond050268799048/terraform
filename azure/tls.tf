resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

output "tls_private_key" { value = "tls_private_key.example_ssh.private_key_pem" }