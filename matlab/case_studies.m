% Original educational companion code, Subrata Pandey manuscript, 2026.
function R = case_studies()
%CASE_STUDIES Synthetic, independently checkable cases from Chapter 24.
V=1; ce=2; cs=1;
r=(cs*V/(2*pi*ce))^(1/3); height=V/(pi*r^2);
R.vessel=struct('radius',r,'height',height,'volumeResidual',pi*r^2*height-V);
x=0; Y=zeros(80,1); U=Y;
for k=1:80
    u=min(1,max(-1,0.2*(1-0.9*x)/(0.2^2+0.1)));
    x=0.9*x+0.2*u; Y(k)=x; U(k)=u;
end
R.control=struct('output',Y,'input',U,'equilibrium',0.8);
R.dispatch=struct('generation',[1.5;1.5],'cost',6.75);
F=1e4; L=2; E=2e11; stress=1e8; delta=1e-3; density=7850;
area=max([F/stress,F*L/(E*delta),1e-5]);
R.member=struct('area',area,'mass',density*L*area);
rng(23,'twister'); A=randn(160,40); A=A./sqrt(sum(A.^2,1));
truth=zeros(40,1); truth([3 12 27])=[1;-0.8;0.6];
b=A*truth+0.02*randn(160,1);
[z,h]=admm_lasso(A,b,0.05,struct('maxit',3000));
R.signal=struct('estimate',z,'truth',truth,'history',h);
end
