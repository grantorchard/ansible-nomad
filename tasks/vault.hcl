pid_file = "./pidfile"

vault {
        address = "{{ vault_addr }}"
}

auto_auth {
	method "cert" {
		name = "nomad-server"
		client_cert = "{{ vault_data_dir }}/tls/tls.cer"
		client_key = "{{ vault_data_dir }}/tls/tls.key"
	}

	sink "file" {
		config = {
			path = "{{ vault_data_dir }}/sink"
		}
	}
}

cache {
  use_auto_auth_token = true
}

storage "file" {
  path = "{{ vault_data_dir }}"
}


# HTTPS listener
listener "tcp" {
  address       = {% raw %}"https://{{ GetInterfaceIP \"ens192\" }}{% endraw %}:8200"
  tls_disable = true
}

