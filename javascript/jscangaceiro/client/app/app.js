const formulario = document.querySelector(".form");
const negociacaoController = new NegociacaoController();

formulario.addEventListener("submit", negociacaoController.adiciona.bind(negociacaoController));



