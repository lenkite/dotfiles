function proxyset() {
	local proxy=$1; shift
	if [[ -z $proxy ]]; then
		echo "Proxy needed as argument"
	else
		echo "Setting proxy to >$proxy<"
		export https_proxy=$proxy
        export http_proxy=$proxy
	fi
}

function proxyblr() {
	proxyset "http://proxy.blrl.sap.corp:8080"
}

function proxysof() {
	proxyset "http://proxy.sofl.sap.corp:8080"
}

function proxywdf() {
	proxyset "http://proxy.wdf.sap.corp:8080"
}

function proxyclear() {
  unset http_proxy
  unset https_proxy
}

alias npmpi='npm install --proxy $http_proxy --http_proxy $http_proxy --https_proxy $https_proxy'
