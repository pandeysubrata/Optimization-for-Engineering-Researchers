% Original educational companion code, Subrata Pandey manuscript, 2026.
function [best,fb,h,info] = pso_book(f,lb,ub,o)
%PSO_BOOK Synchronous global-best PSO; clip and zero boundary velocity.
if nargin<4, o=struct; end
[lb,ub,n]=boxcheck(lb,ub); N=optget(o,'pop',25);
B=optget(o,'maxeval',2500); w=optget(o,'w',0.7298);
c1=optget(o,'c1',1.49618); c2=optget(o,'c2',1.49618);
assert(N>=1 && N==floor(N) && B>=N && B==floor(B));
X=lb'+rand(N,n).*(ub-lb)'; V=zeros(N,n); P=X;
pv=Inf(N,1); fb=Inf; best=lb; nf=0; h=zeros(B,2);
for i=1:N
    pv(i)=book_eval(f,X(i,:)'); nf=nf+1;
    if pv(i)<fb, fb=pv(i); best=X(i,:)'; end
    h(nf,:)=[nf fb];
end
while nf<B
    frozen=best';
    V=w*V+c1*rand(N,n).*(P-X)+c2*rand(N,n).*(frozen-X);
    Z=X+V; clipped=Z<lb' | Z>ub';
    X=min(ub',max(lb',Z)); V(clipped)=0;
    for i=1:N
        fi=book_eval(f,X(i,:)'); nf=nf+1;
        if fi<pv(i), pv(i)=fi; P(i,:)=X(i,:); end
        if fi<fb, fb=fi; best=X(i,:)'; end
        h(nf,:)=[nf fb];
        if nf>=B, break; end
    end
end
h=h(1:nf,:); info=struct('status','evaluation_limit','funcCount',nf);
end
