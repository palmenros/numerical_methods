 function c=sturmsep(p0,inter)
% Calcula, mediante el método de Sturm, el número de raíces distintas del
% polinomio p0 en el intervalo inter sin contar multiplicidad. Con solo un 
% argumento de entrada, calcula el número de raíces positivas de p0.
prec=10^(-8);
n=length(p0);
if nargin == 2
    a=inter(1);
    b=inter(2);
else
    b=1+norm(p0(2:n)/p0(1),inf);       %
    a=1/(1+norm(p0(1:n-1)/p0(n),inf)); % Acotación de McLaurin
end
p(1,1:n)=p0;
g(1)=n;
p1=p0(1:n-1).*(n-1:-1:1);
p(2,1:n-1)=p1;
g(2)=n-1;
r=1;
cont=1;
while any(r)
    [~,r]=deconv(p(cont,1:g(cont)),p(cont+1,1:g(cont+1)));
    aux=find(abs(r)<prec);
    m=length(aux);
    r(aux)=zeros(1,m);
    ind=1;
    while abs(r(ind))==0 && ind<length(r)
        ind=ind+1;
    end
    g(cont+2)=length(r)-ind+1;
    p(cont+2,1:g(cont+2))=-r(ind:length(r));
    cont=cont+1;
end
p=p(1:cont,:);
g=g(1:cont);
sa=zeros(1,cont); % Inicialización
sb=sa;
for i=1:cont
    sa(i)=polyval(p(i,1:g(i)),a);
    sb(i)=polyval(p(i,1:g(i)),b);
end
sa=sa(find(sa)); %#ok<FNDSB>
sb=sb(find(sb)); %#ok<FNDSB>
ca=0;
cb=0;
for i=1:length(sa)-1
    if sa(i)*sa(i+1)<-eps
        ca=ca+1;
    end
end
for i=1:length(sb)-1
    if sb(i)*sb(i+1)<-eps
        cb=cb+1;
    end
end
c=ca-cb;
   
