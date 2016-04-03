import java.io.IOException;
import java.io.ObjectInputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Date;

public class ServidorData {

	private static ServerSocket servidor;
	private final static int porta = 88;
	private static Date data;
	private static Socket conexao;

	public static void main(String[] args) {
		System.out.println("Servidor Data");
		System.out.println("Aluno: Everton Agilar");

		try {
			servidor = new ServerSocket(porta);
			conexao = servidor.accept();
			
			ObjectInputStream in = new ObjectInputStream(conexao.getInputStream());
			
			data = (Date) in.readObject();
			System.out.println("Data: "+ data.toString());
			
			conexao.close();
			servidor.close();

		} catch (IOException e) {} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
	}
}
