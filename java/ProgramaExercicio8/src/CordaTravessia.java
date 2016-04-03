import java.util.Random;
import java.util.concurrent.Semaphore;
import java.util.Random;

public class CordaTravessia {
	
	void iniciaTravessia(){
		
		for (int i = 0; i < 50; i++){
			Morador morador = new Morador(this);
			morador.andaTche();
		}
	}
	
	CordaTravessia(){
		System.out.println("Programa Exercicio 8");
		System.out.println("----------------------------");
		iniciaTravessia();
	}
	
	public static void main(String[] args) {
		new CordaTravessia();
	}
}
