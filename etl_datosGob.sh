#!/usr/bin/env bash

#HaciendoJson y excel de QTotal farmacias
inicio="Descargando el listado de farmacias"
fin="Se generó la lista de farmacias en csv"
armado_csv="Generando cabeceras y columnas de farmacias en excel"

echo "$inicio"
curl https://farmanet.minsal.cl/index.php/ws/getLocales > listado_farmacias.json
while IFS= read -r line; do echo $line; done < listado_farmacias.json
echo "$armado_csv"
echo "FECHA ,ID LOCAL ,NOMBRE LOCAL,COMUNA ,LOCALIDAD ,DIRECCION ,HORA APERTURA ,HORA CIERRE ,TELEFONO ,LATITUD ,LONGITUD ,DIA FUNCIONAMIENTO ,FK REGION ,FK COMUNA ,FK LOCALIDAD " > head_listado_farmacias.csv
jq -r '.[]|[.fecha, .local_id, .local_nombre, .comuna_nombre, .localidad_nombre, .local_direccion, .funcionamiento_hora_apertura, .funcionamiento_hora_cierre , .local_telefono, .local_lat, .local_lng , .funcionamiento_dia, .fk_region , .fk_comuna , .fk_localidad ] | @csv' listado_farmacias.json > listado_farmacias.data
cat head_listado_farmacias.csv listado_farmacias.data > listado_farmacias.csv
echo -e "$fin\n--------"

#Haciendo Json y excel de farmacias turno
echo "$inicio"


curl https://farmanet.minsal.cl/index.php/ws/getLocalesTurnos > farmacias_turno.json
while IFS= read -r line; do echo $line; done < farmacias_turno.json
echo "$armando_csv"
echo "\"FECHA\",\"ID LOCAL\",\"FK REGION\",\"FK COMUNA\",\"FK LOCALIDAD\",\"NOMBRE LOCAL\",\"COMUNA\",\"LOCALIDAD\",\"DIRECCION\",\"HORA APERTURA\",\"HORA CIERRE\",\"TELEFONO\",\"LATITUD\",\"LONGITUD\",\"DIA FUNCIONAMIENTO\"\n" > head_farmacias_turno.csv
jq -r '.[]|[.fecha, .local_id, .fk_region, .fk_comuna, .fk_localidad, .local_nombre, .comuna_nombre, .localidad_nombre, .local_direccion, .funcionamiento_hora_apertura, .funcionamiento_hora_cierre, .local_telefono, .local_lat, .local_lng, .funcionamiento_dia ] | @csv' farmacias_turno.json > farmacias_turno.data
cat head_farmacias_turno.csv farmacias_turno.data > listado_farmacias_turno.csv

echo -e "$fin\n--------"


#Carga CSV en CKAN

#curl -X POST  -H “Content-Type: multipart/form-data”  -H “Authorization: XXXX”  -F “id=<resource_id>” -F “upload=@updated_file.csv”
#curl https://farmanet.minsal.cl/index.php/ws/getLocalesTurnos > curl -X POST https://datos.gob.cl/api/3/action/datastore_create -H "Authorization:  baeccc7d-64c7-46d7-bc19-0fd65a3f9306"  -d '{"resource": {"package_id": "test3"},"description": "Listas","name": "Test Farmacia"}}'




#curl -X POST https://datos.gob.cl/api/3/action/datastore_create -H "Authorization:  baeccc7d-64c7-46d7-bc19-0fd65a3f9306" -d '{"package_id": "test3","resource" : {"package_id": "test3","description": "Lista URL","name": "Test Farmacia"}}' --data-binary @listado_farmacias_turno.csv -H 'Content-type:text/plain; charset=utf-8'
#curl -X POST https://datos.gob.cl/api/3/action/datastore_create -H "Authorization:  baeccc7d-64c7-46d7-bc19-0fd65a3f9306" -d '{"resource": {"package_id": "test3"},  "records": "@farmacias_turno.json"}'

#  curl \
#    -X POST https://datos.gob.cl/api/3/action/datastore_create \
#    -H "Authorization:  baeccc7d-64c7-46d7-bc19-0fd65a3f9306" \
#    -d '{"resource": {"package_id": "test3"}}'\
#     "\"FECHA\",\"ID LOCAL\",\"FK REGION\",\"FK COMUNA\",\"FK LOCALIDAD\",\"NOMBRE LOCAL\",\"COMUNA\",\"LOCALIDAD\",\"DIRECCION\",\"HORA APERTURA\",\"HORA CIERRE\",\"TELEFONO\",\"LATITUD\",\"LONGITUD\",\"DIA FUNCIONAMIENTO\"\n" > head_farmacias_turno.csv



echo "UP"