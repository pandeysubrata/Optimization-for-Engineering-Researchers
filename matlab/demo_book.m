% Original educational companion code, Subrata Pandey manuscript, 2026.
function demo_book()
%DEMO_BOOK Representative examples. Run run_checks first.
f=@(x) sum(x.^2-10*cos(2*pi*x)+10);
o=struct('maxeval',2000,'pop',25); lb=[-5;-5]; ub=[5;5];
rng(2,'twister'); [~,~,hd]=de_book(f,lb,ub,o);
rng(2,'twister'); [~,~,hp]=pso_book(f,lb,ub,o);
figure; semilogy(hd(:,1),max(hd(:,2),1e-14),'LineWidth',1.4); hold on;
semilogy(hp(:,1),max(hp(:,2),1e-14),'LineWidth',1.4);
xlabel('Objective evaluations'); ylabel('Best objective (plot floor 10^{-14})');
legend('DE, one illustrative run','PSO, one illustrative run'); grid on;
R=case_studies(); figure; plot(R.control.output,'LineWidth',1.4);
hold on; plot([1 numel(R.control.output)],[1 1],'--');
xlabel('Sample'); ylabel('Output'); legend('One-step controller','Reference');
end
