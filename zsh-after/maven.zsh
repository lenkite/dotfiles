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
alias mi='mvn -nsu install'
alias mci='mvn -nsu clean install'
alias msci='mvn -nsu -DskipTests clean install'
alias msi='mvn -nsu -DskipTests install'
alias mt='mvn -nsu test'
