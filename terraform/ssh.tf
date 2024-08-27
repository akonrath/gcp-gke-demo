data "google_client_openid_userinfo" "me" {}

resource "google_os_login_ssh_public_key" "default" {
  user = data.google_client_openid_userinfo.me.email
  key  = var.ssh_key
}
