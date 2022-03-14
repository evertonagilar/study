const formulario = document.querySelector(".form");
const dispensaController = new DispensaController();

formulario.addEventListener("submit", dispensaController.adiciona.bind(dispensaController));
document.getElementById("botao-apaga").addEventListener('click', dispensaController.apaga.bind(dispensaController));


