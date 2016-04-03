import java.util.Random;
import java.util.concurrent.Semaphore;

class Morador extends Thread {
	public static final int MAX_ANDA_OESTE = 6;
	public static final int MAX_ANDA_LESTE = 4;
	private static Semaphore sem = new Semaphore(1);
	private static Random r = new Random(100);
	private CordaTravessia corda;
	private static int qtdOeste = 0;
	private static int qtdLeste = 0;

	Morador(CordaTravessia corda){
		this.corda = corda;
	}
	
	private synchronized boolean podeAndarOeste(){
		return (qtdLeste == 0 && qtdOeste <= MAX_ANDA_OESTE);
	}
	
	private synchronized boolean podeAndarLeste(){
		return (qtdOeste == 0 && qtdLeste <= MAX_ANDA_LESTE);
	}

	private void cruzaOeste(){
		if (podeAndarOeste()){
				try {
					qtdOeste++;
					sem.acquire();
					System.out.println("Cruzei a oeste!");
					sem.release();
					qtdOeste--;
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
		}
	}
		
	private void cruzaLeste(){
		if (podeAndarOeste()){
			try {
				qtdLeste++;
				sem.acquire();
				System.out.println("Cruzei a leste!");
				sem.release();
				qtdLeste--;
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
	}

	private synchronized void caminha(){
		if (r.nextInt(100) % 2 == 0) 
			cruzaLeste();
		else
			cruzaOeste();
	}	

	void andaTche(){
		start();
	}
	
	@Override
	public void run() {
		try {
			sleep(new Random().nextInt(5000));
			caminha();
		} catch (InterruptedException e) {
			System.out.println("Puts, a corda caiu!!!");
		}
	}
}
