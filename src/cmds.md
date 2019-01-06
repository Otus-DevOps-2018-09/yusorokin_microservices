docker build -t yurich00/post:1.0 ./post-py

docker build -t yurich00/comment:1.0 ./comment

docker build -t yurich00/ui:1.0 ./ui



docker network create reddit

docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest

docker run -d --network=reddit --network-alias=post yurich00/post:1.0

docker run -d --network=reddit --network-alias=comment yurich00/comment:1.0

docker run -d --network=reddit -p 9292:9292 yurich00/ui:1.0



# new aliases

docker run -d --network=reddit --network-alias=new_post_db --network-alias=new_comment_db mongo:latest && \
docker run -d --network=reddit --network-alias=new_post -e POST_DATABASE_HOST=new_post_db yurich00/post:1.0 && \
docker run -d --network=reddit --network-alias=new_comment -e COMMENT_DATABASE_HOST=new_comment_db yurich00/comment:1.0 && \
docker run -d --network=reddit -p 9292:9292 -e POST_SERVICE_HOST=new_post -e COMMENT_SERVICE_HOST=new_comment yurich00/ui:1.0

# after shrink

docker run -d --network=reddit --network-alias=new_post_db --network-alias=new_comment_db mongo:latest && \
docker run -d --network=reddit --network-alias=new_post -e POST_DATABASE_HOST=new_post_db yurich00/post:2.0_alpine && \
docker run -d --network=reddit --network-alias=new_comment -e COMMENT_DATABASE_HOST=new_comment_db yurich00/comment:2.0_alpine && \
docker run -d --network=reddit -p 9292:9292 -e POST_SERVICE_HOST=new_post -e COMMENT_SERVICE_HOST=new_comment yurich00/ui:4.0_alpine
