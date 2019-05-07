local property = import "property.libsonnet";

{
    "mongo_value.yaml" :  std.manifestYamlDoc({
        mongodbRootPassword: property.mongo_root_pw,
        service :
        {
            nodePort: property.mongo_nodePort,
            type : "NodePort",
        },
       
    } + (if std.objectHas(property, "mongo_nodeSelector") then 
            {   nodeSelector : 
                {   "nodeType" : property.mongo_nodeSelector, 
                }
            }
            else
            {

            }
        )
    ),
    
    "init_mongo.sh" : |||
        #!/bin/bash
        helm del --purge %(project_name)s-mongo
        helm install -f ./mongo_value.yaml --name %(project_name)s-mongo --namespace %(project_name)s stable/mongodb   
    ||| % {project_name: property.project_name},
}
