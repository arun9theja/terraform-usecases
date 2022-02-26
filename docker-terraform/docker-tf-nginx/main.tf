resource "docker_container" "nginx" {
  name  = "test-nginx"
  image = docker_image.nginx.latest

  ports {
    internal = "80"
    external = "8080"
  }
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
}