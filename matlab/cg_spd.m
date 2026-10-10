% Original educational companion code, Subrata Pandey manuscript, 2026.
function [x,h] = cg_spd(A,b,x,tol,maxit)
%CG_SPD Teaching conjugate gradient for a real symmetric positive definite A.
b=b(:); x=x(:); r=b-A*x; p=r; rr=r'*r; h=sqrt(rr);
for k=1:maxit
    if sqrt(rr)<=tol*max(1,norm(b)), break; end
    Ap=A*p; denom=p'*Ap;
    assert(denom>0,'Nonpositive curvature: SPD assumption violated.');
    alpha=rr/denom; x=x+alpha*p; r=r-alpha*Ap; rrnew=r'*r;
    p=r+(rrnew/rr)*p; rr=rrnew; h(end+1,1)=sqrt(rr); %#ok<AGROW>
end
end
