% Original educational companion code, Subrata Pandey manuscript, 2026.
function run_checks()
%RUN_CHECKS Assertions for MATLAB execution before publication/use.
% Not a claim that this file was executed in MATLAB during manuscript creation.
f=@(x) sum(x.^2); g=@(x) 2*x;
[gd,~,~,~]=gd_armijo(f,g,[2;-3],struct('tol',1e-8));
assert(norm(gd)<1e-6);
[x,fv]=bfgs_book(f,g,[2;-3],struct('tol',1e-8));
assert(norm(x)<1e-6 && fv<1e-10);
[gn,nf]=fdgrad(f,[0.3;-0.7]); assert(norm(gn-[0.6;-1.4])<1e-7 && nf==4);
[v,take]=knapsack_dp([2 3 4],[3 4 5],5);
assert(v==7 && isequal(take,[true;true;false]));
keep=nondominated_book([1 2;2 1;3 3;1 2]);
assert(isequal(keep,[true;true;false;true]));
A=diag([1 4 9]); b=[1;2;3];
[x,~]=cg_spd(A,b,zeros(3,1),1e-10,20); assert(norm(A*x-b)<1e-8);
[z,h]=admm_lasso(eye(3),[2;-1;0.1],0.3,struct('tol',1e-8));
assert(norm(z-[1.7;-0.7;0])<1e-6 && all(isfinite(h(:))));
[x,h]=projected_qp(eye(2),[-2;1],[0;0],[1;1],[0.5;0.5],100,1e-8);
assert(norm(x-[1;0])<1e-7);
o=struct('maxeval',251,'pop',10); lb=[-2;-2]; ub=[2;2];
solvers={@random_book,@de_book,@pso_book};
for j=1:numel(solvers)
    rng(5,'twister'); [x,fv,h,info]=solvers{j}(f,lb,ub,o);
    assert(info.funcCount==251 && size(h,1)==251);
    assert(all(x>=lb & x<=ub) && abs(f(x)-fv)<1e-12);
    assert(all(diff(h(:,2))<=1e-12));
    rng(5,'twister'); [x2,fv2]=solvers{j}(f,lb,ub,o);
    assert(isequal(x,x2) && isequal(fv,fv2));
end
rng(9,'twister'); [x,fv,h]=anneal_book(f,[1;1],lb,ub,o);
assert(size(h,1)==251 && all(diff(h(:,2))<=1e-12) && abs(f(x)-fv)<1e-12);
[x,fv,h,info]=pattern_book(f,[1;1],lb,ub,o);
assert(info.funcCount<=251 && abs(f(x)-fv)<1e-12 && all(diff(h(:,2))<=1e-12));
[x,fv,logdata]=bayes1d_book(@(x) (x-0.3)^2,0,1,10);
assert(size(logdata,1)==10 && x>=0 && x<=1 && abs(fv-(x-0.3)^2)<1e-12);
R=case_studies(); assert(abs(R.member.mass-1.57)<1e-12);
assert(abs(R.vessel.volumeResidual)<1e-12 && abs(R.control.output(end)-0.8)<1e-5);
fprintf('All included assertion checks passed in this runtime.\n');
end
