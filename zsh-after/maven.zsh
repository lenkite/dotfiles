mvnhome() {
	if [[ -f ~/.m2/settings.xml ]]; then
		mv ~/.m2/settings.xml ~/.m2/settings.xml.bak
	fi
}

mvnsap() {
	if [[ -f ~/.m2/settings.xml.bak ]]; then
		mv ~/.m2/settings.xml.bak ~/.m2/settings.xml
	fi
}
alias mi='mvn install'
alias mci='mvn clean install'
alias msci='mvn -DskipTests clean install'
alias msi='mvn -DskipTests install'
alias mt='mvn test'
