// Compilar com: java -Xms2m -Xmx2m -XX:+PrintGCDetails -XX:+UseSerialGC GCDemo.java
public class GCDemo{

	static int[] myArray = new int[1024 * 1024 * 1024 * 512];

	public static void main(String[] args){
		System.out.println("Teste GC");
	}
}
