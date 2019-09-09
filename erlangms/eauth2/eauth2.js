const jErlangMs = e$ = function() {
    return {
        purpose() {
            console.log("ErlangMs javascript utils");
            return this;
        },

        autenticate({ server, client_id, redirect_uri, onSuccess, onAccessDenied, onError }) {
            const url = `${server}?response_type=code&client_id=${client_id}&redirect_uri=${redirect_uri}`;
            console.log('Autenticate url: ', url)
            fetch(url)
                //.then(response => response.json())
                .then(response => {
                    onSuccess(response)
                });
            return this;
        }

    }
};