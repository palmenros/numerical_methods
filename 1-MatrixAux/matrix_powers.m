% Create matrices

% Tamaño
s = 4

M = (randi(100, s) / 100) .* (-1).^randi(2, s)

% Number of iterations
n = 100

% Display norms (can predict if limit is 0)

norm1 = norm(M, 1);
norminf = norm(M, inf);
normfrob = norm(M, 'fro');

disp("Norm 1: " + norm1 + ", norminf: " + norminf + ", normfrob: " + normfrob);

% Calculate M^n

for i=1:n
    disp(M);
    M = M * M;
end
