% Crea las matriz de Wilson

M = [ 10 7 8 7; 7 5 6 5; 8 6 10 9; 7 5 9 10]


% Calcula el condicionamiento 2 de una matriz

singular_values = eig(M' * M);
cond2 = sqrt( max(singular_values) / min(singular_values) );

disp("Cond2: " + cond2);

% Matlab conds
matcond2 = cond(M, 2)
matcond1 = cond(M, 1)
matcondInf = cond(M, inf)
matcondFro = cond(M, 'fro')

% Cond1, condInf and condpro must be greater than cond2
disp(all( [matcond1, matcondInf, matcondFro] >= matcond2 ))