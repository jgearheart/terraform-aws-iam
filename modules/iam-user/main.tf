resource "aws_iam_user" "this" {
  count = "${var.create_user == true ? 1 : 0}"

  name                 = "${var.name}"
  path                 = "${var.path}"
  force_destroy        = "${var.force_destroy}"
  permissions_boundary = "${var.permissions_boundary}"
  tags                 = "${var.tags}"
}

resource "aws_iam_user_login_profile" "this" {
  count = "${max(var.create_user == true ? 1 : 0, var.create_iam_user_login_profile == true ? 1 : 0)}"

  user                    = "${aws_iam_user.this.name}"
  pgp_key                 = "${var.pgp_key}"
  password_length         = "${var.password_length}"
  password_reset_required = "${var.password_reset_required}"
}

resource "aws_iam_access_key" "this" {
  count = "1"
  user    = "${aws_iam_user.this.name}"
  pgp_key = "${var.pgp_key}"
}

resource "aws_iam_access_key" "this_no_pgp" {
  count = "0"

  user = "${aws_iam_user.this.name}"
}

resource "aws_iam_user_ssh_key" "this" {
  count = "0"

  username   = "${aws_iam_user.this.name}"
  encoding   = "${var.ssh_key_encoding}"
  public_key = "${var.ssh_public_key}"
}

