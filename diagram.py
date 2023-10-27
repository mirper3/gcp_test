from diagrams import Diagram, Cluster
from diagrams.gcp.network import Network as NET
from diagrams.gcp.compute import ComputeEngine as CE
from diagrams.gcp.network import FirewallRules as FW
from diagrams.gcp.network import ExternalIpAddresses as EIP
from diagrams.gcp.network import LoadBalancing as LB
from diagrams.onprem.network import Nginx
import json

with open("terraform_outputs.json",encoding="utf-8", mode="r") as file:
    data = json.load(file)
    
with Diagram("GCP Infrastructure", show=False):
    pip = ""
    if "o_pip" in data:
        o_pip_value = data ["o_pip"]["value"]
        o_pip = str(o_pip_value)
        ingress = EIP("http://" + o_pip)
        
    with Cluster("VPC"):
        with Cluster("backend service"):
            bck = []
            for key, value in data.items():
                if "o_vm0" in key:
                    o_vm0_value = value["value"]
                    o_vm0 = str(o_vm0_value)
                    print(o_vm0_value)
                    bck.append(CE(str(o_vm0)))
                    
    for i in range(len(bck)):
        ngix =Nginx(f"Docker_VM-0{i+1}")
        bck[i] - ngix
        
    lb = LB("ELB "+pip)
    ingress >> lb >> bck