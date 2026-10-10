% Original educational companion code, Subrata Pandey manuscript, 2026.
function [best,fb,h,info] = de_book(f,lb,ub,o)
%DE_BOOK Generational DE/rand/1/bin; clipping repair; objective budget.
if nargin<4, o=struct; end
[lb,ub,n]=boxcheck(lb,ub); N=optget(o,'pop',30);
B=optget(o,'maxeval',3000); F=optget(o,'F',0.7); CR=optget(o,'CR',0.9);
assert(N>=4 && N==floor(N) && B>=N && B==floor(B));
assert(F>0 && CR>=0 && CR<=1);
X=lb'+rand(N,n).*(ub-lb)'; vals=Inf(N,1); fb=Inf; best=lb;
h=zeros(B,2); nf=0;
for i=1:N
    vals(i)=book_eval(f,X(i,:)'); nf=nf+1;
    if vals(i)<fb, fb=vals(i); best=X(i,:)'; end
    h(nf,:)=[nf fb];
end
while nf<B
    old=X; newX=X; newV=vals;
    for i=1:N
        pool=[1:i-1 i+1:N]; r=pool(randperm(N-1,3));
        v=old(r(1),:)+F*(old(r(2),:)-old(r(3),:));
        mask=rand(1,n)<CR; mask(randi(n))=true;
        z=old(i,:); z(mask)=v(mask); z=min(ub',max(lb',z));
        fz=book_eval(f,z'); nf=nf+1;
        if fz<=vals(i), newX(i,:)=z; newV(i)=fz; end
        if fz<fb, fb=fz; best=z'; end
        h(nf,:)=[nf fb];
        if nf>=B, break; end
    end
    X=newX; vals=newV;
end
h=h(1:nf,:); info=struct('status','evaluation_limit','funcCount',nf);
end
