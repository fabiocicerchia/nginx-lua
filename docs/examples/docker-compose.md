# Example - docker-compose

```yaml
web:
  image: fabiocicerchia/nginx-lua
  volumes:
    - ./templates:/etc/nginx/templates
  ports:
    - "8080:80"
  environment:
    - NGINX_HOST=foobar.com
    - NGINX_PORT=80
```
