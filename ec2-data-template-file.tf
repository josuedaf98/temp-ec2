data "template_file" "user_data_alice_test" {
  template = file("user-data.sh")
  vars = {
    instanceName = lower(local.instance_name)
  }
}