const jErlangMs = e$ = function() {
    return {
        autenticate({ server, client_id, client_secret, redirect_uri, onSuccess, onAccessDenied, onError }) {
            const params = new URLSearchParams(location.search);
            const code = params.get('code');
            if (code == null || code == '') {
                const url = `${server}?response_type=code&client_id=${client_id}&redirect_uri=${redirect_uri}`;
                console.log(`Autenticate redirect to ${url}.`)
                window.location.href = url;
            } else {
                console.log(`Autenticate code ${code} received from ${document.referrer}.`)
                const url = `${server}?grant_type=authorization_code&code=${code}&redirect_uri=${redirect_uri}`;
                const authorizatoinHeader = 'Basic ' + btoa(client_id + ':' + client_secret);
                const optionsFetch = {
                    method: 'POST',
                    mode: 'cors',
                    headers: new Headers({
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'Authorization': authorizatoinHeader
                    })
                }
                fetch(url, optionsFetch)
                    .then(response => response.json())
                    .then(response => {
                        onSuccess(response)
                    });
            }
            return this;
        }
    }
};