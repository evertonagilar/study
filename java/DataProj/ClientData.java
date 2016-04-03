import java.io.IOException;
import java.io.ObjectOutputStream;
import java.net.ConnectException;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.Date;

public class ClientData {

	public static int porta = 88;
	public static String serverName = "localhost"; 
	public static Socket cliente;
	private static Date hoje = new Date();

	public static void main(String[] args) {
		System.out.println("Cliente Data");
		System.out.println("Aluno: Everton Agilar");

		try {
			cliente = new Socket(serverName, porta);
			ObjectOutputStream out = new ObjectOutputStream(cliente.getOutputStream());
			out.writeObject(hoje);
		
		} 
		catch (ConnectException e){
			System.out.println("Servidor nao encontrado!");
		}
		catch (UnknownHostException e) {
			System.out.println("Servidor desconhecido!");
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
