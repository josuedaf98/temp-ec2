resource "aws_instance" "alice_test" {
  ami                    = local.alice_ami
  instance_type          = local.alice_type
  key_name               = local.key_name
  subnet_id              = data.aws_subnet.private_a.id
  vpc_security_group_ids = [data.aws_security_group.alice.id]

  user_data = base64encode(data.template_file.user_data_alice_test.rendered)


  tags = merge({
    Name         = upper(local.instance_name)
    cost_system  = "alice"
    cost_type    = "server"
    system       = "alice"
    type         = "server"
    DFT_SNAPSHOT = "1day"

  }, local.general_tags)

  volume_tags = merge({
    Name        = upper(local.instance_name)
    cost_system = "alice"
    cost_type   = "server"
    system      = "alice"
    type        = "server"

  }, local.general_tags)

  lifecycle {
    ignore_changes = [private_ip, root_block_device, ebs_block_device]
  }
}
