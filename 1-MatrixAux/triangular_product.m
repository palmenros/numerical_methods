% Crear matrices

% Tamaño
s = 4

M1 = (randi(100, s) / 10) .* (-1).^randi(2, s);
T1 = triu(M1)


v = (randi(100, s, 1) / 10) .* (-1).^randi(2, s, 1)

% Multiplicacion por vector
R = zeros(s, 1);

for i=1:s 
    R(i) = dot(T1(i, i:s), v(i:s)');
end

disp("Optimized:");
disp(R);

disp("Matlab:");
disp(T1 * v);

% Multiplicación por otra matroz triangular superior

M2 = (randi(100, s) / 10) .* (-1).^randi(2, s);
T2 = triu(M2);

R2 = zeros(s, s);

% Do not calculate elements outside upper triangle
for j=1:s
    for i=1:j
        % Do not multiply by zeros
        R2(i, j) = dot( T1(i, i:j), T2(i:j, j));
        
        %Debug:
        %disp("i: " + i + ", j: " + j);
        %disp(T1(i, :));
        %disp(T2(:, j));
    end
end

disp("Optimized:");
disp(R2);

disp("Matlab:");
disp(T1 * T2);
