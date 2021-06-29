function x = tridiag(a, b, c, d)
    % DEBUG
    % a = [6 2 4];
    % b = [2 3 5 3];
    % c = [3 9 2];
    % d = [21 69 34 22];

    n = size(b, 2);

    % Preparamos los vectores resultado
    m = zeros(1, n);
    g = zeros(1, n);
    x = zeros(1, n);

    m(1) = b(1);
    g(1) = d(1) / m(1);

    for k = 2:n
        m(k) = b(k) - a(k-1) * c(k-1) / m(k-1);
        g(k) = (d(k) - g(k-1)*a(k-1)) / m(k);
    end 

    x(n) = g(n);
    for k=n-1:-1:1
        x(k) = g(k) - c(k) * x(k+1) / m(k);
    end
    
    % DEBUG
    % La solucion del ejemplo es [3 5 4 2]
    % disp(x);
end