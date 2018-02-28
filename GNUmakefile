TAG=tomgidden/ubuntu-server
ME?=me
CONTAINER?=ubuntu-server
HOMEDIR?=`pwd`

# From https://github.com/solita/docker-systemd/issues/1#issuecomment-218190399
TWEAKS=--cap-add SYS_ADMIN --security-opt seccomp=unconfined --stop-signal=SIGRTMIN+3 --tmpfs /run --tmpfs /run/lock -v /sys/fs/cgroup:/sys/fs/cgroup:ro

KEYFILE=.ssh/authorized_keys

all: run shell

clean:
	-docker kill $(CONTAINER)
	-docker rm $(CONTAINER)

distclean: clean
	-docker rmi $(TAG)

copy_ssh:
	mkdir -p `dirname $(KEYFILE)`
	cp ~/.ssh/id_rsa.pub $(KEYFILE)
#	cp ~/.ssh/authorized_keys $(KEYFILE)
#	cp ~/.ssh/id_ed25519.pub $(KEYFILE)
#	cp ~/.ssh/id_ed25519_docker.pub $(KEYFILE)

build: Dockerfile etc/debconf.txt etc/zsh/zshenv etc/zsh/zshrc
	docker build . --build-arg user=$(ME) -t $(TAG)

run:
	docker run --rm $(TWEAKS) -d -p 8022:22 -v $(HOMEDIR):/home/$(ME) --name $(CONTAINER) $(TAG)

shell:
	docker exec -it -u $(ME) $(CONTAINER) zsh

ssh:
	ssh -p 8022 me@localhost
