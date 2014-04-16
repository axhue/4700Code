% clear all
clearvars
clearvars -GLOBAL
close all
format shorte
set(0,'DefaultFigureWindowStyle','docked')
global C Gn V mu Gv Dn Bv Em DnM muM A B

C.q_0 = 1.60217653e-19;             % electron charge
C.hb = 1.054571596e-34;             % Dirac constant
C.h = C.hb*2*pi;                    % Planck constant
C.m_0 = 9.10938215e-31;             % electron mass
C.kb = 1.3806504e-23;               % Boltzmann constant
C.eps_0 = 8.854187817e-12;          % vacuum permittivity
C.mu_0 = 1.2566370614e-6;           % vacuum permeability
C.c = 299792458;                    % speed of light

EpiSi = C.eps_0*11.68
muSi = 450*1e-4 % cm2 V-1s-1 * 1/(100 cm/m)^2
DnSi = muSi*C.kb*300/C.q_0; % D = kt/q mu 
niSi = 1e10*1e6; % 1/cm^3 * (100 cm/m)^3 intrinsic concentration

Coupled = 1;
SCF = 0;

nx = 2000;
l = 1e-6;
x =linspace(0,l,nx);

dx = x(2)-x(1);
xm = x(1:nx-1) + 0.5*dx;

% Poisson equation d^2V/dx^2 = -1/EpiSi rho(x)
% Gv V = -dx^2/EpiSi rho(x)
% E = - dV/dx


Rho = zeros(1,nx);


FormGv(nx,0);

mu = ones(1,nx)*muSi;
Dn = ones(1,nx)*DnSi;

n = zeros(nx,nx);

Nd = 1e14 * 1e6; % Const. 1e18/cm3 (100 cm/m)^3

Dp = ones(1,nx).*Nd; % doping

n0 = (Dp + sqrt(Dp.^2 + 4* niSi*niSi))/2;

MaxNumIter = 1000;

nV = zeros(1,nx);
nV(1) = n0(1);      % n0 at left end

for lbc = 0:-1e-3:-40e-3
    lbc
    Bv(1) = lbc;
    
    for i = 1:MaxNumIter
        
        V = Gv\(-dx^2/EpiSi*Rho' + Bv');
        FillGn(nx,dx,SCF);
        n = Gn\nV';
        if (Coupled)
            Rho = C.q_0*(Dp - n'); % update Rho
            Rho(1) = 0;
        end
        
        gradn = (n(2:nx)-n(1:nx-1))/dx;
        nM = (n(2:nx)+n(1:nx-1))/2;
        
        JnDiff = C.q_0*DnM.*gradn';
        JnDrift = C.q_0*muM.*nM'.*Em;
        
        
        if abs(n - n0') < Dp'*1e-5
            break
        end
        
        
        n0 = n';
    end
    
    subplot(2,2,1),plot(x,V);
    axis([0 l -0.05 0.01])
    hold on
    subplot(2,2,2),plot(xm,Em);
    axis([0 l -15e4 1e4])
    hold on 
    subplot(2,2,3),plot(x,n);
    hold on
    axis([0 l 0 5e20])
    subplot(2,2,4),plot(xm,JnDiff,'r');
    hold on
    subplot(2,2,4),plot(xm,JnDrift,'b');
    axis([0 l -5e5 5e5])
%     Jerr = (JnDrift+JnDiff)/max(abs([JnDrift, JnDiff])*100);
%     subplot(2,2,4),plot(xm,Jerr);
    
    pause(0.0001)
    
end
