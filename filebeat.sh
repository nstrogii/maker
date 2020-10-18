#!/bin/bash
curl -X POST "http://localhost:5601/api/saved_objects/index-pattern/filebeat-7.9.2" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
 {
"attributes": {
 "title": "filebeat-7.9.2","timeFieldName": "@timestamp"
 }
}'
