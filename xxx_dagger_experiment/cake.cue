package cake

import (
	"dagger.io/dagger"
  "duponey.cloud/docker"
)

Host: docker.#Host & {
	host: "10.0.4.218"
	user: "dmp"
	privatekey: dagger.#Secret
	passphrase: dagger.#Secret
	trust: true
}

Controller: docker.#Controller & {
	host: Host
}

runThis: docker.#Command & {
	controller: Controller
	args: ["run", "-d", "debian", "bash"]
}
