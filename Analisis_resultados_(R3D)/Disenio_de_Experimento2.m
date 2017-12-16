E1=load('Errores_plano1.mat');
R1=[E1.RMS_P0;E1.RMS_P2;E1.RMS_P3;E1.RMS_S0;E1.RMS_S2;E1.RMS_S3];
E2=load('Errores_plano2.mat');
R2=[E2.RMS_P0;E2.RMS_P2;E2.RMS_P3;E2.RMS_S0;E2.RMS_S2;E2.RMS_S3];
E3=load('Errores_plano3.mat');
R3=[E3.RMS_P0;E3.RMS_P2;E3.RMS_P3;E3.RMS_S0;E3.RMS_S2;E3.RMS_S3];

cali = [-1 -1 -1 -1 -1 -1;
       -1 -1 -1 -1 -1 -1;
       -1 -1 -1 -1 -1 -1;
        1  1  1  1  1  1;
        1  1  1  1  1  1;
        1  1  1  1  1  1];
    
dist = [-1 -1 -1 -1 -1 -1;
        0  0  0  0  0  0;
        1  1  1  1  1  1;
       -1 -1 -1 -1 -1 -1;
        0  0  0  0  0  0;
        1  1  1  1  1  1];
metodo = [-1 -1  0  0  1  1;
          -1 -1  0  0  1  1;
          -1 -1  0  0  1  1;
          -1 -1  0  0  1  1;
          -1 -1  0  0  1  1;
          -1 -1  0  0  1  1];
      
gamma = [1 -1  1  -1  1  -1;
         1 -1  1  -1  1  -1;
         1 -1  1  -1  1  -1;
         1 -1  1  -1  1  -1;
         1 -1  1  -1  1  -1;
         1 -1  1  -1  1  -1];

     t1= [cali(:),dist(:),metodo(:),gamma(:),R1(:)]
     t2= [cali(:),dist(:),metodo(:),gamma(:),R2(:)]
     t3= [cali(:),dist(:),metodo(:),gamma(:),R3(:)]




