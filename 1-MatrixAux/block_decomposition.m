%M = input("Introduce una matriz M: ");
%N = input("Introduce una matriz N: ");

%Matrices aleatorias
M = randi(100, 4) / 10
N = randi(100, 4) / 10

n1 = input("Introduce tamaño del primer bloque: ");

s1 = n1 + 1;

% Calcula los bloques de M
sM = size(M, 1);

A = M(1:n1, 1:n1);
B = M(1:n1, s1:sM);
C = M(s1:sM, 1:n1);
D = M(s1:sM, s1:sM);

% Calcula los bloques de N
sN = size(N, 1);

E = N(1:n1, 1:n1);
F = N(1:n1, s1:sN);
G = N(s1:sN, 1:n1);
H = N(s1:sN, s1:sN);

% Calcular producto directo

P = M*N;

% Calcular producto por bloques

Q = zeros(size(P));
Q(1:n1, 1:n1) = A*E + B*G;
Q(1:n1, s1:sM) = A*F + B*H;
Q(s1:sM, 1:n1) = C*E + D*G;
Q(s1:sM, s1:sM) = C*F + D*H;

disp(P);
disp(Q);
if all(all(abs(P-Q) < 0.00000001))
    disp("Coinciden");
else
    disp("No coinciden");
end
