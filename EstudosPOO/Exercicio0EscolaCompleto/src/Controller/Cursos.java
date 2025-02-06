package Controller;

import java.util.ArrayList;
import java.util.List;

import Model.Aluno;
import Model.Professor;

public class Cursos {
    private String nomeCurso;
    private Professor professor;
    private List<Aluno> alunos;
    
    public Cursos(String nomeCurso, Professor professor) {
        this.nomeCurso = nomeCurso;
        this.professor = professor;
        this.alunos = new ArrayList<>();
    }

    public void adicionarAluno(Aluno aluno){
        alunos.add(aluno);
    }
    
    public void exibirInformacoesCurso(){
        System.out.println("Nome do curso: "+nomeCurso);
        System.out.println("============================");
        System.out.println("Nome Professor: "+professor.getNome());
        System.out.println("============================");
        int i = 1;
        for (Aluno aluno : alunos) {
            System.out.println(i+"." + " "+aluno.getNome());
            i++;
        }
    }
    
}