#!/bin/bash
curl -X POST "http://localhost:5601/api/saved_objects/index-pattern/metricbeat-7.6.2" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
 {
"attributes": {
 "title": "metricbeat-7.6.2","timeFieldName": "@timestamp"
 }
}'
