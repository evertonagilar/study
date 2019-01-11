package aula.io;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import javax.enterprise.context.ApplicationScoped;
import javax.enterprise.event.Observes;
import java.util.Collection;
import java.util.List;

import static java.util.stream.Collectors.toList;

@ApplicationScoped
public class AulaCDIApplication {

    private Collection<Pessoa> listaPessoas = new java.util.LinkedList<Pessoa>();

    @PostConstruct
    private void init(){
        System.out.println("Init AulaCDIApplication...");
    }

    @PreDestroy
    private void destroy(){
        System.out.println("Destroy AulaCDIApplication...");
    }

    public void onChangePessoa(@Observes PessoaEvent event){

        List<String> nomes = listaPessoas.stream()
                                .filter(p -> p.getNome().equals(event.getPessoa().getNome()))
                                .map(Pessoa::getNome)
                                .collect(toList());

        boolean existe = listaPessoas.stream()
                            .anyMatch(p -> p.getNome().equalsIgnoreCase(event.getPessoa().getNome()));

        if (existe){
            System.out.format("AulaCDIApplication registra pessoa %s\n", event.getPessoa().getNome());
            listaPessoas.add(event.getPessoa());
        }else{
            System.out.format("AulaCDIApplication já tinha a pessoa %s\n", event.getPessoa().getNome());
        }
        listaPessoas.forEach(System.out::println);
    }



}
