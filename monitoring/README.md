# Setup grafana

1. Copy the "monitoring" folder and rename it.

2. Set the GRAFANA_CONFIG path in the .env for your node.

3. Start the container.

# Make grafana token
When the grafana container is up an running you can create your grafana token by GUI or API.
You can use curl: (Here "admin" is the username and password for BasicAuth, "apikeycurl" is the name of your key you can choose and yourgrafana:port is the address of your grafana which you have to set.)
	
    curl -X POST -H "Content-Type: application/json" -d '{"name":"apikeycurl", "role": "Admin"}' http://admin:admin@yourgrafana:port/api/auth/keys

If successful you'll get a responds looking like:

	{"id":1,"name":"apikeycurl","key":"eyJrIjoiSWR4SFNab0E4WnluSHZlQ0hoMHJGOGE4RllrVnBVMWoiLCJuIjoiYXBpa2V5Y3VybCIsImlkIjoyfQ=="}

The "key" property is your grafana token. You won't be able to see it again so make shure you save it. 
	
# Upload alerts
Run the set-grafana-data.sh script to set the variables.
	To do so you have to use the source or simply . command to run it in the existing shell. Add the address of your grafana as first argument and your grafana token as the second:
	source ./set-grafana-data.sh your-grafana-address your-grafana-token
	
Run upload-grafana-alerts.sh to upload the preconfigured alerts to your grafana.