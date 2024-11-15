## sample application

## Node.js application with Nginx proxy and Redis database

this project is the only that is not written with terraform just as an example.

also this project is going to be deployed at namespace node-redis

Project structure:
```
.
├── README.md
├── nginx.yaml
├── redis.yaml
├── web.yaml
├── web2.yaml
├── nginx
│   │ 
│   └── nginx.conf
└── web
    ├── Dockerfile
    ├── package.json
    └── server.js

2 directories, 9 files


## Deploy order

```
kubectl apply -f redis.yml
kubectl apply -f web.yml
kubectl apply -f web2.yml
kubectl apply -f nginx.yml
```


## Expected result



```
kubectl get services -n node-redis
```

## Testing the app

After the application starts, navigate to `<EXTERNAL-IP>` in your web browser or run:

```
curl <EXTERNAL-IP>/web1
curl <EXTERNAL-IP>/web2
web1: Total number of visits is: 1
```

```
curl <EXTERNAL-IP>
web1: Total number of visits is: 2
```
```
curl <EXTERNAL-IP>
web2: Total number of visits is: 3
```



## Stop and remove the containers

```
kubectl delete -f redis.yml
kubectl delete -f web.yml
kubectl delete -f web2.yml
kubectl delete -f nginx.yml
```

