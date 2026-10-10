% Original educational companion code, Subrata Pandey manuscript, 2026.
function [best,fb,logdata] = bayes1d_book(f,lb,ub,budget)
%BAYES1D_BOOK Fixed-kernel deterministic GP/EI on a candidate grid.
% Educational: no hyperparameter fitting, noise learning or continuous EI solve.
assert(isscalar(lb) && isscalar(ub) && ub>lb && budget>=3);
assert(budget==floor(budget) && budget<=1001);
grid=linspace(0,1,1001)'; X=[0;0.5;1]; y=zeros(3,1);
for i=1:3, y(i)=book_eval(f,lb+(ub-lb)*X(i)); end
assert(all(isfinite(y)),'GP example requires finite deterministic values.');
ell=0.15;
for k=4:budget
    ym=mean(y); ys=max(std(y),1e-8); yn=(y-ym)/ys;
    K=exp(-0.5*((X-X')/ell).^2)+1e-9*eye(numel(X));
    L=chol(K,'lower'); Kg=exp(-0.5*((X-grid')/ell).^2);
    mu=Kg'*(L'\(L\yn)); V=L\Kg;
    sd=sqrt(max(0,1-sum(V.^2,1)'));
    improvement=min(yn)-mu; z=improvement./max(sd,1e-12);
    Phi=0.5*erfc(-z/sqrt(2)); phi=exp(-z.^2/2)/sqrt(2*pi);
    EI=improvement.*Phi+sd.*phi;
    used=min(abs(grid-X'),[],2)<1e-12; EI(used)=-Inf;
    [~,j]=max(EI); xn=grid(j);
    ynext=book_eval(f,lb+(ub-lb)*xn);
    assert(isfinite(ynext),'Nonfinite response cannot train this GP.');
    X(end+1,1)=xn; y(end+1,1)=ynext; %#ok<AGROW>
end
[fb,j]=min(y); best=lb+(ub-lb)*X(j);
logdata=[lb+(ub-lb)*X y];
end
