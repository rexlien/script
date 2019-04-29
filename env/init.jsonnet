
local property = import "env/property.libsonnet";
local nodePortUtil = import "node_port_service.libsonnet";
local kube = import "kube.libsonnet";

{

  'mysql_value.yaml': std.manifestYamlDoc({
      mysqlRootPassword: property.mysql_root_pw,
      initializationFiles: property.mysql_init_sql_content,
      
    }),
  
  'init_mysql.sh': |||
    #!/bin/bash
    helm del --purge %(project_name)s 
    sleep 3
    helm install --wait -f ./mysql_value.yaml --name %(project_name)s-mysql --namespace %(project_name)s stable/mysql
    kubectl get service -n %(project_name)s
    kubectl apply -f mysql_node_port.yaml
    ##until kubectl port-forward svc/%(project_name)s-mysql 3306 -n %(project_name)s; do
    ##    sleep 1
    ##done
  ||| % {project_name: property.project_name, helm_mysql_value: property.helm_mysql_value},

  'mysql_node_port.yaml': std.manifestYamlDoc(
  
       nodePortUtil.NodePortService(property.project_name + "-sql-port", "gu-mysql", property.project_name, 3306, 30000),
  
    ),
  

  'import_sql.sh' : ||| 
    #!/bin/bash
    mysql -h 127.0.0.1 -P 30000 -uroot -p%(pw)s %(project_name)s < %(import_file)s
  ||| % {project_name: property.project_name, import_file: property.mysql_import_file, pw: property.mysql_root_pw},

 'init_redis.sh': |||
    #!/bin/bash
    helm del --purge %(project_name)s-redis
    helm install --name %(project_name)s-redis --namespace %(project_name)s --set master.service.nodePort=%(node_port)d,password=%(pw)s,master.service.type=NodePort stable/redis
  ||| % {project_name : property.project_name, node_port: property.redis_nodePort, pw : property.redis_pw},

}