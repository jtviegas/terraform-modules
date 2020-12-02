# entity
tables, content loader through cloud storage(buckets) and rest api

![diagram][diagram]

## procedure
* download this folder :
```
svn export -q  https://github.com/jtviegas/terraform-scripts/trunk/entity ./entity
```
* `cd entity`
* login to your development `aws` account and `export TV_VAR_accountid=<aws user account id>`;
* make sure you have `terraform` installed, at least version `v0.12.13`'
* configure terraform remote state management first with `run.sh` : 
```
$ ./run.sh
this_folder: /Users/jtviegas/Desktop/tmp/entity
  usage:
  run.sh {state|loader|api|tables} {deploy|undeploy} {dev|pro} {<appname>} [<region>=eu-west-1]


$ ./run.sh state deploy dev testapp
...
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:
bucket-arn = arn:aws:s3:::testapp-dev-terraform-state
bucket-id = testapp-dev-terraform-state
table-arn = arn:aws:dynamodb:eu-west-1:692391178777:table/testapp-dev-terraform-state-lock
table-id = testapp-dev-terraform-state-lock
```
* configure entities loader: 
```
$ ./run.sh loader deploy dev testapp
...
Apply complete! Resources: 7 added, 0 changed, 0 destroyed.
```
* configure the api:
```
$ ./run.sh api deploy dev testapp
...
Apply complete! Resources: 17 added, 0 changed, 0 destroyed.

Outputs:
url = https://2m2qarsgoc.execute-api.eu-west-1.amazonaws.com/dev
```
* now create the tables, say for `entity1`, according to the `app` name and `environment`, 
we will create one table this time named `testapp-dev-entity1`, so we have to edit the `tables` variable in `variables.tf`:
```
...
variable "tables" {
  description = "tables to be created as part of the app, format: app-env-entity"
  type        = list(string)
  default     = [ "testapp-dev-entity1"]
}
...
```
...and we run now the script:
```
$ ./run.sh tables deploy dev testapp
...
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```
* now say we want to add entries to `entity1`, we will have to copy those entries in the format 
found in the `resources` folder into the entities bucket created before with the name `testapp-dev-entities`, 
be sure to copy the elements with public read access;

![entities][entities]

![entity1][entity1]

* and now place a file named `trigger` in the root of the bucket:

![trigger][trigger]

* we should see now those entries imported into table `testapp-dev-entity1`:

![table][table]

* we should now also be able to confirm the image links in the entity records are publicly accessible:

![image][image]


* moreover we can also query the api url for entities, as it provides path parameters `entities/{app}/{entity}` and `entities/{app}/{entity}/{id}`:
```
$ curl https://2m2qarsgoc.execute-api.eu-west-1.amazonaws.com/dev/entities/testapp/entity1
[{"date":1544227200000,"number":3,"notes":"demasiado radical para alguns, em saldo","category":"categoria N","images":[{"type":"image/png","href":"https://s3.eu-west-1.amazonaws.com/testapp-dev-entities/entity1/3_1.png"}],"family":"familia A","price":0.34,"id":3,"name":"pneus nao redondos","subcategory":"subcategoria D"},{"date":1543881600000,"number":2,"notes":"e amarela mas esta com ferrugem","category":"categoria V","images":[],"family":"familia X","price":99.01,"id":2,"name":"porta amarela","subcategory":"subcategoria S"},{"date":1535760000000,"number":1,"notes":"e uma peca muito boa em optimo estado","category":"categoria A","images":[{"type":"image/png","href":"https://s3.eu-west-1.amazonaws.com/testapp-dev-entities/entity1/1_1.png"},{"type":"image/png","href":"https://s3.eu-west-1.amazonaws.com/testapp-dev-entities/entity1/1_2.png"}],"family":"familia C","price":12.34,"id":1,"name":"peca ferrugenta","subcategory":"subcategoria C"}]

$ curl https://2m2qarsgoc.execute-api.eu-west-1.amazonaws.com/dev/entities/testapp/entity1/1
{"date":1535760000000,"number":1,"notes":"e uma peca muito boa em optimo estado","category":"categoria A","images":[{"type":"image/png","href":"https://s3.eu-west-1.amazonaws.com/testapp-dev-entities/entity1/1_1.png"},{"type":"image/png","href":"https://s3.eu-west-1.amazonaws.com/testapp-dev-entities/entity1/1_2.png"}],"family":"familia C","price":12.34,"id":1,"name":"peca ferrugenta","subcategory":"subcategoria C"}
```

* now we can use the script to update the infrastructure or eventually destroy it using the opposite sequence of creation;

```
$ ./run.sh tables undeploy dev testapp
...
Destroy complete! Resources: 1 destroyed.
...
$ ./run.sh api undeploy dev testapp
...
Destroy complete! Resources: 17 destroyed.
...
$ ./run.sh loader undeploy dev testapp
...
Destroy complete! Resources: 7 destroyed.
...
$ ./run.sh state undeploy dev testapp
...
Destroy complete! Resources: 2 destroyed.
```

[entities]: assets/entities.png "entities"
[entity1]: assets/entity1.png "entity1"
[trigger]: assets/trigger.png "trigger"
[table]: assets/table.png "table"
[trigger]: assets/trigger.png "trigger"
[image]: assets/image.png "image"
[diagram]: assets/diagram.png "diagram"

