CREATE OR REPLACE PROCEDURE inserealuno(p_matricula IN aluno.matricula%TYPE, p_nome IN aluno.nome%TYPE,p_email IN aluno.email%TYPE, p_vbolsa in aluno.vbolsa%TYPE, p_isVoluntario IN aluno.isVoluntario%TYPE,p_cargo IN aluno.cargo%TYPE, p_projeto IN aluno.projeto%TYPE)
IS
BEGIN
   INSERT INTO aluno VALUES (p_matricula, p_nome, p_email, p_vbolsa, p_isVoluntario,p_cargo, p_projeto);
EXCEPTION
   WHEN dup_val_on_index THEN
   RAISE_APPLICATION_ERROR(-20010, 'Aluno duplicado');
END;
/


CREATE OR REPLACE PROCEDURE updatealuno
IS
  CURSOR C IS SELECT MATRICULA, VBOLSA FROM ALUNO;
BEGIN
   FOR rec_aluno IN C LOOP
     UPDATE ALUNO
        SET cargo = CASE WHEN rec_aluno.vbolsa > 2000 THEN 'JUNIOR' ELSE 'GRADUANDO' END
     WHERE matricula = rec_aluno.matricula;
   END LOOP;
   COMMIT;
END;
/

CREATE OR REPLACE FUNCTION nome_projeto(matricula IN aluno.matricula%TYPE)
return aluno.projeto%TYPE
IS
   CURSOR C IS SELECT MATRICULA,PROJETO FROM ALUNO;
BEGIN
   for rec_aluno IN C LOOP
       if rec_aluno.matricula = matricula THEN
          return (rec_aluno.projeto);
       END IF;
  END LOOP;
  COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE atualizaprojeto
IS
   CURSOR C IS SELECT PROJETO FROM ALUNO;
BEGIN
    for rec_aluno IN C LOOP
        UPDATE ALUNO
          SET projeto = 'Toshiba'
        WHERE rec_aluno.projeto ='Samsung';
    END LOOP;
    COMMIT;
END;
/

CREATE OR REPLACE FUNCTION contaAlunoprojeto(projeto IN aluno.projeto%TYPE)
RETURN INTEGER
IS
    CONT INTEGER;
    CURSOR C IS SELECT PROJETO FROM ALUNO;
BEGIN
    for rec_aluno IN C LOOP
       if rec_aluno.projeto = projeto THEN
          cont:= cont + 1;
        END IF;
    END LOOP;
    return (cont);
    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE update_alunobolsa
IS
    CURSOR C IS SELECT ISVOLUNTARIO, VBOLSA FROM ALUNO;
BEGIN
    for rec_aluno IN C LOOP
        UPDATE ALUNO
          SET isVoluntario = 0, vbolsa = 616.00
          WHERE rec_aluno.isVoluntario = 1;

    END LOOP;
    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE relatorio
IS
    CURSOR C IS SELECT GERENTE, SMASTER, NOME FROM PROJETO;
    CURSOR D IS SELECT PROJETO, NOME FROM ALUNO;
BEGIN
    FOR rec_projeto IN C LOOP
        DBMS_OUTPUT.PUT_LINE('Projeto'+ rec_projeto.nome);
        DBMS_OUTPUT.PUT_LINE('Scrum  master:'+ rec_projeto.smaster);
        DBMS_OUTPUT.PUT_LINE('Gerente :'+ rec_projeto.gerente);
        DBMS_OUTPUT.PUT_LINE('Alunos participantes:');
        FOR rec_aluno IN D LOOP
            if rec_aluno.projeto = rec_projeto.nome then
               DBMS_OUTPUT.PUT_LINE(rec_aluno.nome);
            END IF;
        END LOOP;
        COMMIT;
    END LOOP;
    COMMIT;
END;
/

CREATE OR REPLACE TRIGGER aluno_trigger
BEFORE INSERT, UPDATE ON Aluno
AS
BEGIN
   IF 
