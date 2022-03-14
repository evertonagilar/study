const formulario = document.querySelector(".form");
const dispensaController = new DispensaController();

formulario.addEventListener("submit", dispensaController.adiciona.bind(dispensaController));



