% Original educational companion code, Subrata Pandey manuscript, 2026.
function [x,loss] = adam_ls(A,b,o)
%ADAM_LS Mini-batch ridge least squares with bias-corrected Adam.
if nargin<3, o=struct; end
[M,n]=size(A); b=b(:); assert(numel(b)==M && M>0);
epochs=optget(o,'epochs',100); batch=optget(o,'batch',32);
alpha=optget(o,'alpha',0.01); lambda=optget(o,'lambda',0);
assert(batch>=1 && batch==floor(batch) && alpha>0 && lambda>=0);
x=zeros(n,1); m=x; v=x; t=0; loss=zeros(epochs,1);
for e=1:epochs
    order=randperm(M);
    for start=1:batch:M
        idx=order(start:min(start+batch-1,M));
        g=A(idx,:)'*(A(idx,:)*x-b(idx))/numel(idx)+lambda*x;
        t=t+1; m=0.9*m+0.1*g; v=0.999*v+0.001*(g.^2);
        mh=m/(1-0.9^t); vh=v/(1-0.999^t);
        x=x-alpha*mh./(sqrt(vh)+1e-8);
    end
    loss(e)=0.5*norm(A*x-b)^2/M+0.5*lambda*norm(x)^2;
end
end
