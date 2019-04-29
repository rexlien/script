local kube = import "kube.libsonnet";

{

NodePortService(service_name, selector, namespace, service_port, nodePort) : kube._Object("v1", "Service", service_name) {
    
    metadata+: {
            namespace: namespace
    },
    spec: {
        
        
        selector: {
            app: selector,
            
        },
    
        type: "NodePort",

         ports: [
            {   name : service_name,
                port : service_port,
                targetPort : service_port,
                nodePort : nodePort,
                protocol : "TCP",
            }
         ],
    },
    
   
}

}
