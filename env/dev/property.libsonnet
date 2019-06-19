//Stub

{ 
    project_name : "test",
    helm_mysql_value : "",
    mysql_import_file : "",
    mysql_init_sql_content:
    {
        
    },
    
    mysql_root_pw : "1234",
    mysql_nodePort : "30000",
    
    redis_pw: "secret",
    redis_nodePort : 30001,

    mongo_root_pw: "1234",
    mongo_nameSpace : "test-mongo",
    //mongo_nodeSelector : "mongo",
    mongo_nodePort : 30002,
    mongo_storageClass : "fast-disks",
}