SHELL := /bin/bash
ELASTIC_VERSION = 7.9.2
KIBANA_VERSION = 7.9.2
FILEBEAT_VERSION = 7.9.2
METRICBEAT_VERSION = 7.6
PREFIX = demo

all: install_helm3 add_repo_elastic update_repo install_elasticsearch install_kibana install_metricbeat install_filebeat check_port port_forward w8_service_run add_index-pattern

install_helm3:
	curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

add_repo_elastic:
	helm repo add elastic https://helm.elastic.co

update_repo:
	helm repo update

install_elasticsearch:
	helm install ${PREFIX}-elastic elastic/elasticsearch -f ./elastic.yaml --version ${ELASTIC_VERSION}

install_kibana:
	helm install ${PREFIX}-kibana elastic/kibana --version ${KIBANA_VERSION}

install_metricbeat:
	helm install ${PREFIX}-metricbeat elastic/metricbeat --version ${METRICBEAT_VERSION}

install_filebeat:
	helm install ${PREFIX}-filebeat elastic/filebeat --version ${FILEBEAT_VERSION}

check_port:
	while [ "$$(kubectl get pod | grep ${PREFIX}-kibana | awk '{print $$3}')" != "Running" ]; \
	do \
		sleep 5; \
		echo "Waiting for Pod up${PREFIX}-kibana."; \
	done

port_forward:
	kubectl port-forward --address 0.0.0.0 deployment/${PREFIX}-kibana-kibana 5601 &

w8_service_run:
	while [ "$$(kubectl get pod | grep ${PREFIX}-kibana | awk '{print $$2}' | tail -1)" != "1/1" ]; \
	do \
		sleep 5; \
		echo "Waiting for servise up ${PREFIX}-kibana."; \
	done

add_index-pattern:
	./filebeat.sh & ./metricbeat.sh

clean:
	helm del ${PREFIX}-elastic ${PREFIX}-kibana ${PREFIX}-metricbeat ${PREFIX}-filebeat \
	&& kill -9 $$(ps | grep kubectl | awk '{print $$1}')

uninstall:
	helm del ${PREFIX}-elastic ${PREFIX}-kibana ${PREFIX}-metricbeat ${PREFIX}-filebeat \
	&& helm repo remove elastic \
	&& rm /usr/local/bin/helm \
	&& kill -9 $$(ps | grep kubectl | awk '{print $$1}')

