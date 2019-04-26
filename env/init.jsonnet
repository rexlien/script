
local property = import "env/property.libsonnet";

{

  'mysql_value.yaml': std.manifestYamlDoc({
      mysqlRootPassword: property.mysql_root_pw,
      initializationFiles: property.mysql_init_sql_content
    }),
  
  'init_mysql.sh': |||
    #!/bin/bash
    helm del --purge %(project_name)s 
    sleep 3
    helm install --wait -f ./mysql_value.yaml --name %(project_name)s --namespace %(project_name)s stable/mysql
    kubectl get service -n %(project_name)s
    until kubectl port-forward svc/%(project_name)s-mysql 3306 -n %(project_name)s; do
        sleep 1
    done
  ||| % {project_name: property.project_name, helm_mysql_value: property.helm_mysql_value},

  'import_sql.sh' : ||| 
    #!/bin/bash
    mysql -h 127.0.0.1 -P 3306 -uroot -p%(pw)s %(project_name)s < %(import_file)s
  ||| % {project_name: property.project_name, import_file: property.mysql_import_file, pw: property.mysql_root_pw},
  
}