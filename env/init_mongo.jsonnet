local property = import "property.libsonnet";

{
    "mongo_value.yaml" :  std.manifestYamlDoc({
        mongodbRootPassword: property.mongo_root_pw,
        service :
        {
            nodePort: property.mongo_nodePort,
            type : "NodePort",
        }
    

       
    } + (if std.objectHas(property, "mongo_nodeSelector") then 
            {   nodeSelector : 
                {   "nodeType" : property.mongo_nodeSelector, 
                }
            }
            else
            {

            }
        )
    + (if std.objectHas(property, "mongo_storageClass") then
        {
             persistence: 
            {
                storageClass : property.mongo_storageClass
            }
        } else {

        }
        )
    ),
    
    "init_mongo.sh" : |||
        #!/bin/bash
        helm del %(project_name)s-mongo -n %(project_name)s
        helm install -f ./mongo_value.yaml %(project_name)s-mongo --namespace %(project_name)s --create-namespace stable/mongodb   
    ||| % {project_name: property.project_name},
}
