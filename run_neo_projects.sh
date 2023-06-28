#!/bin/bash

clear

function neo_start_certs() {
    echo ""
    echo "*********************************************************************************************************"
    echo ""
    echo "Project steps:"
    echo ""
    echo "This project deploys neo4j with a self-signed certificate. To make this happen, the following was done:"
    echo ""
    echo "  - A private key and self-signed server certificate were generated."
    echo ""
    echo "  - The needed directories were created to hold the certificates, certs copied in, and needed permissions set."
    echo "    - mkdir -p /var/lib/neo4j/certificates/bolt/trusted"
    echo "    - mkdir -p /var/lib/neo4j/certificates/https/trusted"
    echo ""
    echo "    - cp public.crt /var/lib/neo4j/certificates/bolt/trusted"
    echo "    - cp public.crt /var/lib/neo4j/certificates/https/trusted"
    echo "    - cp public.crt /var/lib/neo4j/certificates/bolt/"
    echo "    - cp private.key /var/lib/neo4j/certificates/bolt/"
    echo "    - cp public.crt /var/lib/neo4j/certificates/https/"
    echo "    - cp private.key /var/lib/neo4j/certificates/https/"
    echo ""
    echo "    - chown -R neo4j:neo4j /var/lib/neo4j/certificates"
    echo "    - chmod 400 /var/lib/neo4j/certificates/bolt/private.key"
    echo "    - chmod 644 /var/lib/neo4j/certificates/bolt/public.crt"
    echo "    - chmod 644 /var/lib/neo4j/certificates/bolt/trusted/public.crt"
    echo "    - chmod 400 /var/lib/neo4j/certificates/https/private.key"
    echo "    - chmod 644 /var/lib/neo4j/certificates/https/public.crt"
    echo "    - chmod 644 /var/lib/neo4j/certificates/https/trusted/public.crt"
    echo ""
    echo "  - The neo4j.conf was updated with:"  
    echo "    - dbms_ssl.policy.bolt.enabled=true"
    echo "    - dbms.ssl.policy.bolt.base_directory=certificates/bolt"
    echo "    - dbms.ssl.policy.bolt.private_key=private.key"
    echo "    - dbms.ssl.policy.bolt.public_certificate=public.crt"
    echo "    - dbms.ssl.policy.bolt.trusted_dir=trusted"
    echo "    - dbms.ssl.policy.bolt.client_auth=NONE"
    echo ""
    echo "    - dbms.ssl.policy.https.enabled=true"
    echo "    - dbms.ssl.policy.https.base_directory=certificates/https"
    echo "    - dbms.ssl.policy.https.private_key=private.key"
    echo "    - dbms.ssl.policy.https.public_certificate=public.crt"
    echo "    - dbms.ssl.policy.https.trusted_dir=trusted"
    echo "    - dbms.ssl.policy.https.client.auth=NONE"
    echo ""
    echo "Items to study in this docker-compose project:"
    echo ""
    echo "  - docker/certs/docker-compose.yml"
    echo "  - docker/env/base_4.4.env"
    echo "  - docker/certs/volumes/certs/.."
    echo ""
    echo "Docs: https://neo4j.com/docs/operations-manual/4.4/security/ssl-framework/"  
    echo ""
    echo "Tips & tricks:"
    echo ""
    echo "  - Prior to launching in browser for first time import the server cert and root cert into your keystore (see images in readme). The certificates are found in the 'certs' directory off the root of this project: myCA.pem and public.crt. Typically, one can double-click on them and import into the keystore once prompted."
    echo "  - Certs were generated following https://ko-fi.com/post/Neo4j-and-self-signed-certificate-on-Windows-S6S2I0KQT"
    echo "Issues that may come up:"
    echo "  - Only provided a .pfx file. This contains both the server certificate and private key. These will need to be extracted to have them separately on disk - done via openssl commands."
    echo "  - Common browser access issues are due to not having the root and intermediate certs of the signing CA in the browser's/user's keystore. This will result in a noticeable red error in the browser URL, asking if a user want's to proceed, etc. The root and intermedite certs can be obtained a couple of ways and imported manually or via script. Once in place and trusted the cert will be recognized as legit and the browser issues will go away."
    echo ""
	docker-compose -f docker/certs/docker-compose.yml up -d
	echo ""
	echo "Project started in docker container..."
        echo "Open the Neo4j browser at --> https://localhost:8473"
	echo ""
   echo ""
   echo "*********************************************************************************************************"
   echo ""
}

function neo_stop_certs() {
    echo ""
        docker-compose -f docker/certs/docker-compose.yml down
        echo ""
}

function neo_start_5.x_cluster() {
    echo ""
    echo "*********************************************************************************************************"
    echo ""
    echo "Project steps:"
    echo ""
    echo "This project deploys neo4j 5.x with three primary nodes in a cluster. To make this happen, the following was done:"
    echo ""
    echo "Items to study in this docker-compose project:"
    echo ""
    echo "  - docker/cluster/5.x/docker-compose.yml"
    echo "  - docker/env/base_v5.env"
    echo "  - docker/env/primary1.env"
    echo "  - docker/env/primary2.env"
    echo "  - docker/env/primary3.env"
    echo ""
    echo "Docs: https://neo4j.com/docs/operations-manual/current/clustering/setup/deploy/"
    echo ""
        docker-compose -f docker/cluster/5.x/docker-compose.yml up -d
	echo ""
	echo "Project started in docker container..."
    echo "Open the Neo4j browser at --> http://localhost:8474"
	echo ""
   echo ""
   echo "*********************************************************************************************************"
   echo ""
}

function neo_stop_5.x_cluster() {
    echo ""
        docker-compose -f docker/cluster/5.x/docker-compose.yml down
        echo ""
}

function neo_start_5.x_pri_sec_cluster() {
    echo ""
    echo "*********************************************************************************************************"
    echo ""
    echo "Project steps:"
    echo ""
    echo "This project deploys neo4j 5.x with one primary and one secondary node in a cluster. Additionally, the GDS plugin"
    echo "is installed on the secondary node and SSR (server side routing) is configured."
    echo ""
    echo "Items to study in this docker-compose project:"
    echo ""
    echo "  - docker/cluster/5.x_primary_secondary/docker-compose.yml"
    echo "  - docker/env/base_v5_pri_sec.env"
    echo "  - docker/env/primary1.env"
    echo "  - docker/env/secondary1.env"
    echo "  - docker/env/ssr_v5.env"
    echo "  - docker/env/ssr_sec_v5.env"
    echo ""
    echo "Docs: https://neo4j.com/docs/graph-data-science/current/production-deployment/neo4j-cluster/"
    echo "Docs: https://neo4j.com/docs/operations-manual/current/clustering/setup/routing/#clustering-routing"
    echo ""
        docker-compose -f docker/cluster/5.x_primary_secondary/docker-compose.yml up -d
	echo ""
	echo "Project started in docker container..."
    echo "Open the Neo4j browser at (for primary) --> http://localhost:8474"
    echo "Open the Neo4j browser at (for secondary/gds) --> http://localhost:9474/browser/"
    
	echo ""
    echo "Process to bring secondary online with cluster and see SSR config:"
    echo ""
    echo "  - Upon intial startup, run a SHOW SERVERS. The secondary server will in the the state of 'Free' Run the following to enable it:"
    echo "      enable server '<secondary server GUID>'"
    echo "  - Next, create a database with the following topology: CREATE DATABASE test1 topology 1 primary 1 secondary"
    echo "  - Then, change to the 'test1' database and run the following command to see the routing:"
    echo "     call dbms.cluster.routing.getRoutingTable({}, 'test1')"
    echo "  - If logged into the GDS secondary, use localhost:9687 for the bolt URL in the Neo4j Browser"
    echo "  - Once logged in, validate the GDS plugin install by running 'RETURN gds.version()'"
    echo ""
   echo "*********************************************************************************************************"
   echo ""
}

function neo_stop_5.x_pri_sec_cluster() {
    echo ""
        docker-compose -f docker/cluster/5.x_primary_secondary/docker-compose.yml down
        echo ""
}

function docker_compose_status() {
    echo ""
    echo "Current status of projects running in docker-compose..."
    echo ""
        docker-compose ls
        echo ""
}




menu(){
echo -ne "
Neo4j Projects Menu

1. Start Neo4j 4.4 with certificates
2. Stop Neo4j 4.4 with certificates
3. Start Neo4j 5.x cluster (3 primaries)
4. Stop Neo4j 5.x cluster
5. Start Neo4j 5.x cluster with GDS (1 primary 1 secondary)
6. Stop Neo4j 5.x cluster
7. Check for running projects...
8. Exit
'Choose an option:' "
        read a
        case $a in
	        1) neo_start_certs ; menu ;;
            2) neo_stop_certs ; menu ;;
	        3) neo_start_5.x_cluster ; menu ;;
            4) neo_stop_5.x_cluster ; menu ;;
	        5) neo_start_5.x_pri_sec_cluster ; menu ;;
            6) neo_stop_5.x_pri_sec_cluster ; menu ;;
            7) docker_compose_status ; menu ;;
		    8) exit 0 ;;
		*) echo -e $red"Wrong option."$clear; WrongCommand;;
        esac
}

clear
menu
