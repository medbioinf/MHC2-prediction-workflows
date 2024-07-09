docker-imgs:
	docker build -t medbioinf/mhc2-predictions-python:latest -f docker/python/Dockerfile .
	docker pull quay.io/medbioinf/mixmhc2pred
