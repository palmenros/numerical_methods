A = randi(100, 4) / 10;

% Norma 1
norm1 = max(sum(abs(A)))
 
% Norma inf
norminf = max(sum(abs(A), 2))

% Norma Frobenius

normfrob = sqrt(sum(sum(abs(A).^2)))

% Comando norm
matnorm1 = norm(A, 1)
matnorminf = norm(A, inf)
matnormfrob = norm(A, 'fro')