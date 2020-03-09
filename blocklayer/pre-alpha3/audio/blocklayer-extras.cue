BlockLayer:: {

	// Some URI grammar helpers
	URI:: {
		IP:: 4 * [ uint8 ]

		PrivateIP:: IP
		PrivateIP:: [10, ...uint8] | [192, 168, ...] | [172, >=16 & <=32, ...]

		IPURI:: "^[0-9]{1,3}[.][0-9]{1,3}[.][0-9]{1,3}[.][0-9]{1,3}$"
		DomainName:: "^(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?.)+[a-z0-9][a-z0-9-]{0,61}[a-z0-9]$"

		DomainOrIp:: =~ DomainName | IPURI

		Port:: uint8

		User:: =~ "^[a-zA-Z0-9_.~!$&'()*+,;=:-]+$"
	}
}
