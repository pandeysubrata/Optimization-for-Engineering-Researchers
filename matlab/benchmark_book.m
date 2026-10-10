% Original educational companion code, Subrata Pandey manuscript, 2026.
function results = benchmark_book(output_dir)
%BENCHMARK_BOOK Equal-budget teaching harness. Produces real results when run.
if nargin<1, output_dir='benchmark_output'; end
if ~exist(output_dir,'dir'), mkdir(output_dir); end
names={'random','pattern','DE','PSO'}; seeds=[2 3 5 7 11 13 17 19 23 29];
B=2000; lb=[-5;-5]; ub=[5;5];
f=@(x) sum(x.^2-10*cos(2*pi*x)+10); % Rastrigin, optimum 0
results=struct([]); row=0;
for a=1:numel(names)
    for r=1:numel(seeds)
        rng(seeds(r),'twister'); row=row+1; timer=tic;
        o=struct('maxeval',B,'pop',25); err=''; h=[];
        try
            switch names{a}
                case 'random', [x,fv,h,info]=random_book(f,lb,ub,o);
                case 'pattern'
                    x0=lb+(ub-lb).*rand(2,1);
                    [x,fv,h,info]=pattern_book(f,x0,lb,ub,o);
                case 'DE', [x,fv,h,info]=de_book(f,lb,ub,o);
                case 'PSO', [x,fv,h,info]=pso_book(f,lb,ub,o);
            end
            violation=max([0;lb-x;x-ub]);
            success=isfinite(fv) && fv<=1e-4 && violation<=1e-10;
            count=info.funcCount; status=info.status;
        catch ME
            x=nan(2,1); fv=Inf; violation=Inf; success=false;
            count=NaN; status='exception'; err=ME.message;
        end
        elapsed=toc(timer);
        results(row).algorithm=names{a};
        results(row).problem='Rastrigin2'; results(row).seed=seeds(r);
        results(row).budget=B; results(row).x=x;
        results(row).fval=fv; results(row).violation=violation;
        results(row).success=success; results(row).funcCount=count;
        results(row).seconds=elapsed; results(row).status=status;
        results(row).error=err; results(row).history=h;
    end
end
metadata=struct('matlab_version',version,'computer',computer, ...
                'toolboxes',ver,'budget',B,'seeds',seeds, ...
                'note','Same seed labels alone do not justify paired tests.');
save(fullfile(output_dir,'raw_runs.mat'),'results','metadata');
T=struct2table(rmfield(results,{'x','history'}));
writetable(T,fullfile(output_dir,'runs.csv'));
end
