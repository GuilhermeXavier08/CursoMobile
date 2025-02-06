package View;

import java.util.Scanner;

import Controller.Cursos;
import Model.Professor;

public class App {
    public static void main(String[] args) throws Exception {
        Scanner sc = new Scanner(System.in);
        Professor professor = new Professor("José", "191.456.379.35", 15000);
        Cursos cursos = new Cursos("Curso POO", professor);
        int operacao;
        boolean continuar = true;
        while (continuar) {
            System.out.println("Escolha a opção desejada");
            System.out.println("1. Cadastrar aluno");
            System.out.println("2. Informações do curso");
            System.out.println("3. Sair");
            System.out.println("=============================");
            
        }
    }
}
