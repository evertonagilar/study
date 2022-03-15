const formulario = document.querySelector(".form");
const dispensaController = new DispensaController();

formulario.addEventListener("submit", dispensaController.adiciona.bind(dispensaController));
document.getElementById("botao-apaga").addEventListener('click', dispensaController.apaga.bind(dispensaController));
document.getElementById("botao-importa").addEventListener('click', dispensaController.importa.bind(dispensaController));




const getDatePickerTitle = elem => {
    // From the label or the aria-label
    const label = elem.nextElementSibling;
    let titleText = '';
    if (label && label.tagName === 'LABEL') {
        titleText = label.textContent;
    } else {
        titleText = elem.getAttribute('aria-label') || '';
    }
    return titleText;
}



const elems = document.querySelectorAll('.datepicker_input');
for (const elem of elems) {
    const datepicker = new Datepicker(elem, {
        'format': 'dd/mm/yyyy',
        title: getDatePickerTitle(elem)
    });
}

Date.prototype.addDays = function (num) {
    var value = this.valueOf();
    value += 86400000 * num;
    return new Date(value);
}