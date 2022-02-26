resource "docker_image" "centos-python" {
  name = "centos-python"
  build {
    path = "."
  }
}

resource "docker_container" "centos-python-container" {
  name  = "centos-python-container"
  image = docker_image.centos-python.latest
}