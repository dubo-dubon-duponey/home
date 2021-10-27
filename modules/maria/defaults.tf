####################################################################
# Default values for this container
# Some values can be overridden with variables (image name, nickname, port)
####################################################################


locals {
  defaults = {
    nickname      = "maria"
    image         = "library/mariadb:10.6-focal" // dubo-dubon-duponey/mariadb:bullseye-2021-10-15"
    privileged    = false
    read_only     = true
    restart       = "always"
    expose_type   = "tcp"
    devices       = []
    group_add     = []
    command       = [
      "mysqld",
        "--datadir=/data",
        "--port=3306",
        "--transaction-isolation=READ-COMMITTED",
        "--character-set-server=utf8mb4",
        "--collation-server=utf8mb4_unicode_ci",
        "--max-connections=512",
        "--innodb-rollback-on-timeout=OFF",
        "--innodb-lock-wait-timeout=120"
    ]
    extra_caps  = [
      "CAP_CHOWN", "CAP_DAC_OVERRIDE",
      "SETUID", "SETGID",
    ]
    port          = 3306
    labels        = {
    }
  }
}
