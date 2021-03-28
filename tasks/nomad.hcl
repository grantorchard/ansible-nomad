datacenter = "{{ hashicorp_datacenter }}"

data_dir  = "{{ nomad_data_dir }}"

bind_addr = {% raw %}"{{ GetInterfaceIP \"ens192\" }}"{% endraw %}

ports {
  http = 4646
  rpc  = 4647
  serf = 4648
}

{% if role == "server" %}
server {
  enabled          = true
  bootstrap_expect = 3
}
{% endif %}

consul {
  address = "127.0.0.1:8500"
}

vault {
  enabled   = true
  address   = "{{ vault_addr }}"
	namespace = "{{- vault_namespace -}}"
	{% if role == "server" %}create_from_role = "nomad"{% endif %}
}

{% if role == "client" %}
meta {
    "connect.sidecar_image" = "envoyproxy/envoy:v1.16.0"
  }
client {
	enabled = true
	options {
			"docker.privileged.enabled" = "true"
			"driver.raw_exec.enable" = "1"
	}
}
{% endif %}

retry_join = [
      "provider=vsphere category_name=hashi tag_name=nomad host=hlcorevc01.humblelab.com user=administrator@vsphere.local password=VMware123! insecure_ssl=true"
]