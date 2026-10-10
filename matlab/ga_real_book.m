% Original educational companion code, Subrata Pandey manuscript, 2026.
function [best,fb,h] = ga_real_book(f,lb,ub,o)
%GA_REAL_BOOK Elitist real-coded GA: tournament, blend, Gaussian mutation.
if nargin<4, o=struct; end
[lb,ub,n]=boxcheck(lb,ub); N=optget(o,'pop',30);
B=optget(o,'maxeval',3000); sigma=optget(o,'sigma',0.08);
assert(N>=2 && N==floor(N) && B>=N && B==floor(B));
X=lb'+rand(N,n).*(ub-lb)'; val=zeros(N,1); nf=0;
fb=Inf; best=lb; h=zeros(B,2);
for i=1:N
    val(i)=book_eval(f,X(i,:)'); nf=nf+1;
    if val(i)<fb, fb=val(i); best=X(i,:)'; end
    h(nf,:)=[nf fb];
end
while nf<B
    Y=X; vy=val; Y(1,:)=best'; vy(1)=fb;
    for i=2:N
        r=randi(N,2,2); parents=zeros(2,1);
        for j=1:2
            [~,q]=min(val(r(:,j))); parents(j)=r(q,j);
        end
        a=rand(1,n); z=a.*X(parents(1),:)+(1-a).*X(parents(2),:);
        z=z+sigma*(ub-lb)'.*randn(1,n).*(rand(1,n)<1/n);
        z=min(ub',max(lb',z)); fz=book_eval(f,z'); nf=nf+1;
        Y(i,:)=z; vy(i)=fz;
        if fz<fb, fb=fz; best=z'; end
        h(nf,:)=[nf fb];
        if nf>=B, break; end
    end
    X=Y; val=vy;
end
h=h(1:nf,:);
end
