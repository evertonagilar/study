#/bin/bash
# Author: Everton de Vargas Agilar

clear
echo "Docker-deploy 1.0 por Everton de Vargas Agilar"

echo "Gerando o pacote com maven..."
mvn clean package
if [ $? -eq 0 ]; then
	PROJ_FILE=$(find target/*.war | sed '1!d')
	IMAGE_NAME="proj_$$"
	echo "Publicando o pacote $PROJ_FILE no container docker com glassfish..."
	docker run --rm --name $IMAGE_NAME -p 8080:8080 -dit glassfish
	docker exec $IMAGE_NAME /usr/local/glassfish4/bin/asadmin start-database
	docker cp $PROJ_FILE $IMAGE_NAME:/usr/local/glassfish4/glassfish/domains/domain1/autodeploy/
	docker attach $IMAGE_NAME
else
	echo "Publicação cancelada!"
fi



