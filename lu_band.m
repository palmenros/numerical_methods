%% Pedimos una matriz al usuario

%A = [2 3 0 0; 6 3 9 0; 0 2 5 2; 0 0 4 3];
%p = 2

A = input("Introduce una matriz: ");
p = input("Introduce el semiancho de banda: ");
n = size(A, 1);

%DEBUG
%disp("Comienza LU banda");
%disp(A);

%% Factorización LU banda

for k = 1:n

    % Podemos guardar en A las nuevas matrices L y U, porque una vez
    % utilizamos un elemento de A no lo volvemos a utilizar
    
    % Primero calculamos la primera fila de U y la guardamos en A
    
    % Después calculamos la primera columna de L y la guardamos en A
    % (excepto el elemento diagonal, que sabemos que siempre es 1)
    
    % Calculamos la k-esima fila de U

    %Rango 1:k-1 adecuado a matrices banda
    rango = max(1,k-p+1):min(k-1, k+p-1);
    
    for j=max(k,k-p+1):min(n,k+p-1)
        A(k, j) = A(k, j) - A(k, rango) * A(rango, j);
    end

    if A(k, k) == 0
        error("La matriz no admite factorización LU");
    end

    % Calculamos la k-esima columna de L

    for j=max(k+1, k-p+1):min(n, k+p-1)
        A(j, k) = (A(j, k) - A(j, rango) * A(rango, k)) / A(k, k);
    end
          
    %DEBUG
    %disp(A);
end

%DEBUG
disp(A);

%% Resolvemos sistemas con la matriz calculada

resolver_otro_sistema = true;

while resolver_otro_sistema
    
    % Pedimos al usuario un vector de términos independientes
    
    % Ejemplo:
    %b = [21 69 34 22];
    
    %Solución del ejemplo:
    %x = [3 5 4 2]
    
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
        %Rango de 1:i-1 adecuado a la matriz banda (se conserva la estructura
        %en factorización LU)
        rango = max(1,i-p+1):min(i-1, i+p-1);
        
        w(i) = b(i) - A(i, rango) * w(rango).';
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

    for i=n-1:-1:1
       %Rango de i+1:n adecuado a la matriz banda (se conserva la estructura
       %en factorización LU)
       rango = max(i+1,i-p+1):min(n, i+p-1); 
        
       u(i) = (w(i) - A(i, rango) * u(rango).' ) / A(i, i);
    end

    disp("La solución es:")
    disp(u);
    
    str = input("¿Resolver otro sistema? [S]/n: ", 's');
    if str == 'n'
        resolver_otro_sistema = false;
    end
end 