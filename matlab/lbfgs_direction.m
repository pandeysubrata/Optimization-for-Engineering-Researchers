% Original educational companion code, Subrata Pandey manuscript, 2026.
function p = lbfgs_direction(g,S,Y)
%LBFGS_DIRECTION Two-loop inverse action; columns are oldest-to-newest pairs.
q=g(:); m=size(S,2); assert(isequal(size(S),size(Y)));
a=zeros(m,1); rho=a;
for i=m:-1:1
    ys=Y(:,i)'*S(:,i); assert(ys>0,'Need positive curvature pairs.');
    rho(i)=1/ys; a(i)=rho(i)*(S(:,i)'*q); q=q-a(i)*Y(:,i);
end
if m>0
    gamma=(S(:,m)'*Y(:,m))/(Y(:,m)'*Y(:,m));
else
    gamma=1;
end
r=gamma*q;
for i=1:m
    beta=rho(i)*(Y(:,i)'*r); r=r+S(:,i)*(a(i)-beta);
end
p=-r;
end
