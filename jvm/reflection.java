public class reflection{


    public static void main(String[] args){

        System.out.println("Obtendo os tipos das classes com Reflection");

        String hello = "string hello";
        System.out.println("hello -> "+ hello.getClass().getName());
        System.out.println("String hello -> "+ String.class.getName());
      

        String[] myArray = {"gol", "fusca", "parati"};
        System.out.println("myArray -> "+ myArray.getClass().getName());

        int[] myArrayDeInt = {1, 2, 3};
        System.out.println("myArrayDeInt -> "+ myArrayDeInt.getClass().getName());

        int x = 10;
        System.out.println("int x -> "+ int.class.getName());
        System.out.println("int x -> "+ Integer.valueOf(x).getClass().getName());

        reflection o = new reflection();
        System.out.println("reflection o -> "+ o.getClass().getName());
        System.out.println("reflection o -> "+ o.getClass().getTypeName());
        System.out.println("reflection -> "+ reflection.class.getName());

        System.out.println("boolean -> "+ boolean.class.getName());

        
        
        
        

    }

}