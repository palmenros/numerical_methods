%% Pedimos una matriz al usuario

% Matriz ejemplo del libro:
%A = [1 2 1 3; 1 1 1 4; 2 1 4 10; -1 -3 7 5];

A = input("Introduce una matriz: ");

n = size(A, 1);

%DEBUG
%disp("Comienza LU");
%disp(A);

%% Factorización LU

for k = 1:n

    % Podemos guardar en A las nuevas matrices L y U, porque una vez
    % utilizamos un elemento de A no lo volvemos a utilizar
    
    % Primero calculamos la primera fila de U y la guardamos en A
    
    % Después calculamos la primera columna de L y la guardamos en A
    % (excepto el elemento diagonal, que sabemos que siempre es 1)
    
    % Calculamos la k-esima fila de U

    for j=k:n
        A(k, j) = A(k, j) - A(k, 1:k-1) * A(1:k-1, j);
    end

    if A(k, k) == 0
        error("La matriz no admite factorización LU");
    end

    % Calculamos la k-esima columna de L

    for j=k+1:n
        A(j, k) = (A(j, k) - A(j, 1:k-1) * A(1:k-1, k)) / A(k, k);
    end
          
    %DEBUG
    %disp(A);
end

%DEBUG
%disp(A);

%% Resolvemos sistemas con la matriz calculada

resolver_otro_sistema = true;

while resolver_otro_sistema
    
    % Pedimos al usuario un vector de términos independientes
    
    % Ejemplo del libro:
    %b = [45 48 101 -4];
    
    b = input("Introduce un vector: ");

    % Para resolver A*u=b resolvemos por remonte los dos sistemas triangulares
    % L*w=b y U*u=w

    %% Resolvemos L*w = b

    w = zeros(1, n);

    % Caso base de remonte
    % Como la matriz L tiene unos en la diagonal, no necesitamos dividir por el
    % elemento de la diagonal

    w(1) = b(1);

    for i=2:n
       w(i) = b(i) - A(i, 1:i-1) * w(1:i-1).';
    end

    %DEBUG
    %disp(w);
    
    %% Resolvemos U*u=w

    u = zeros(1, n);


    % En este caso la diagonal no tiene por qué ser uno, así que tenemos que
    % ejecutar el método de remonte incluyendo la división por el elemento
    % diagonal

    % Caso base de remonte
    u(n) = w(n) / A(n, n);

    for i=(n-1):-1:1
       u(i) = (w(i) - A(i, i+1:n) * u(i+1:n).' ) / A(i, i);
    end

    disp("La solución es:")
    disp(u);
    
    str = input("¿Resolver otro sistema? [S]/n: ", 's');
    if str == 'n'
        resolver_otro_sistema = false;
    end
end 