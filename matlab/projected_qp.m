% Original educational companion code, Subrata Pandey manuscript, 2026.
function [x,h] = projected_qp(H,c,lb,ub,x,maxit,tol)
%PROJECTED_QP Convex box-QP via fixed-step projected gradient.
[lb,ub,n]=boxcheck(lb,ub); c=c(:); x=min(ub,max(lb,x(:)));
assert(all(size(H)==[n n]) && norm(H-H','fro')<1e-10*max(1,norm(H,'fro')));
e=eig((H+H')/2); assert(min(e)>=-1e-12 && max(e)>0);
alpha=1/max(e); h=zeros(maxit,2);
for k=1:maxit
    z=min(ub,max(lb,x-alpha*(H*x+c)));
    residual=norm(x-z,Inf)/alpha; x=z;
    h(k,:)=[0.5*x'*H*x+c'*x residual];
    if residual<=tol, break; end
end
h=h(1:k,:);
end
