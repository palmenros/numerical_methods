% Sistema triangular inferior

% Create matrices

% Tamaño
s = 4

M = tril ((randi(100, s) / 10) .* (-1).^randi(2, s))
b = (randi(100, s, 1) / 10) .* (-1).^randi(2, s, 1)

% Solve

x = zeros(s, 1);

x(1) = b(1) / M(1, 1);
for i=2:s
    st = 1;
    en = i-1;
    x(i) = (b(i) - dot(x(st:en), M(i, st:en))) / M(i, i);
end

disp("Solutions to Ax=b:");

disp(x);
disp(M\b);
