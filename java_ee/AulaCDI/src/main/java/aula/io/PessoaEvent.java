package aula.io;

public class PessoaEvent {
    private Pessoa pessoa;

    public PessoaEvent() {
    }

    public PessoaEvent(Pessoa pessoa) {
        this.pessoa = pessoa;
    }

    public Pessoa getPessoa() {
        return pessoa;
    }

}
