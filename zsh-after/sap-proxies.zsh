function proxyset() {
	local proxy=$1; shift
	if [[ -z $proxy ]]; then
		echo "Proxy needed as argument"
	else
		echo "Setting proxy to >$proxy<"
		export http_proxy=$proxy
	fi
}

function proxyblr() {
	proxyset "https://proxy.blrl.sap.corp:8080"
}

function proxysof() {
	proxyset "https://proxy.sofl.sap.corp:8080"
}

function proxywdf() {
	proxyset "https://proxy.wdf.sap.corp:8080"
}

function proxyclear() {
  unset http_proxy
  unset https_proxy
}
