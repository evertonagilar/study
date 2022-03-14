const campos = [
    document.querySelector("#data"),
    document.querySelector("#quantidade"),
    document.querySelector("#valor")
];

const formulario = document.querySelector(".form");

formulario.addEventListener("submit", function (event) {
    const tr = document.createElement("tr");
    campos.forEach(campo => {
        const td = document.createElement("td");
        td.textContent = campo.value;
        tr.appendChild(td);
    })

    const volume = document.createElement("td");

    // quantidade x valor
    volume.textContent = campos[1].value * campos[2].value;
    tr.appendChild(volume);

    const tbody = document.querySelector("table tbody");
    tbody.appendChild(tr);

    campos[0].value = "";
    campos[1].value = 1;
    campos[0].value = 0;
    campos[0].focus();



    event.preventDefault();
});




