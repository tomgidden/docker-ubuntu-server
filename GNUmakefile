TAG=tomgidden/ubuntu-server
USER=me

# From https://github.com/solita/docker-systemd/issues/1#issuecomment-218190399
TWEAKS=--cap-add SYS_ADMIN --security-opt seccomp=unconfined --stop-signal=SIGRTMIN+3 --tmpfs /run --tmpfs /run/lock -v /sys/fs/cgroup:/sys/fs/cgroup:ro


build: Dockerfile debconf.txt
	docker build . --build-arg user=$(USER) -t $(TAG)

run:
	docker run --rm $(TWEAKS) -d -p 8022:22 -v `pwd`/home:/home $(TAG)
