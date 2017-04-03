close all; clear all; clc
%%%%OPTIONS%%%%
plotting = 1; %plots surface if =1
Datalength = 70; %dont touch plz :)
%%%%%%%%%%%%%%%


%%%data import%%%
files = dir('Tdata/*.txt');

%generate empty arrays for data storage
Tset = ones(Datalength,length(files));
T = zeros(Datalength,length(files));
pos = ones(Datalength,length(files));
for j = 1:length(files)
    pos(:,j) = pos(:,j).*[0:69]';
end

%data is importet
for k = 1:length(files)
    filename = files(k).name;
    data{k} = importdata(strcat('Tdata/', filename));
    %extract temperatures
    for n = 1:Datalength
        T(n,k) = data{k}(n);
        Tset(n,k) = Tset(n,k).*data{k}(length(data{k}));
    end
end

%set up data for desired format
datax = [];
datay = [];
dataz = [];

for i = 1:length(files)
    datax = [datax,Tset(:,i)'];
    datay = [datay,pos(:,i)'];
    dataz = [dataz,T(:,i)'];
end
% return
% data:
% Tset1 = ones(1,70)*1000;
% T1 = importdata('Tdata/Tdataset1000.txt');
% pos1 = 0:69;
% 
% Tset2 = ones(1,70)*965;
% T2 = importdata('Tdata/Tdataset965.txt');
% pos2 = 0:69;
% 
% Tset3 = ones(1,70)*935;
% T3 = importdata('Tdata/Tdataset935.txt');
% pos3 = 0:69;
% 
% Tset4 = ones(1,70)*900;
% T4 = importdata('Tdata/Tdataset900.txt'); %sidste punkt er genereret så det er falsk
% pos4 = 0:69;
% 
% desired dataformat
% datax = [Tset1,Tset2,Tset3,Tset4];
% datay = [pos1,pos2,pos3,pos4];
% dataz = [T1(1:70,:)',T2(1:70,:)',T3(1:70,:)',T3(1:70,:)'];

%surface fit
plotfit = fit([datax',datay'],dataz','poly15');

%surface plot
if plotting == 1
plot(plotfit,[datax',datay'],dataz')
xlabel('Tset')
ylabel('Displacement')
zlabel('T')
end

%get z
p = coeffvalues(plotfit);
vecx = 900:1:1000;
vecy = 0:1:70;
[x,y] = meshgrid(vecx,vecy);
z = p(1)+p(2).*x+p(3).*y+p(4).*x.*y+p(5).*y.^2+p(6).*x.*y.^2+p(7).*y.^3+p(8).*x.*y.^3+p(9).*y.^4+p(10).*x.*y.^4+p(11).*y.^5;

%derivative
[px,py] = gradient(z,vecx,vecy);
  
%User-input
prompt = 'What is the melting point of your sample? (integer)';
Tdes = input(prompt);
%Tdes = 900

%get isotherm of Tdesire
desz = Tdes-0.50<z & z<Tdes+0.50;
desx = x(desz);
desy = y(desz);
desdzdy = py(desz); 
if plotting == 1
figure
plot3(desx,desy,z(desz),'LineWidth',3 )
hold on
surf(x,y,z)
xlabel('Tset')
ylabel('Displacement')
zlabel('T')
grid on
end
 
%plot isotherm
figure
plot(desx,desy,'r*');
grid on
xlabel('Tset')
ylabel('Displacement')

%make fit
linfit = polyfit(desx,desy,3);
hold on 
yfit = linfit(1).*x.^3 + linfit(2).*x.^2 + linfit(3).*x + linfit(4);
plot(x,yfit,'b');
grid on
axis([900 1000 -10 70])

%plot derivative of points in respect to displacement
figure
plot(desx,desdzdy,'r.');
grid on
xlabel('Tset')
ylabel('dT/mm')

%promt speed
prompt = 'At what speed are you running in mm/h?';
speed = input(prompt);

%plot speed correction
desdzdyws = speed.*desdzdy;
figure
plot(desx,desdzdyws,'b.')
grid on
xlabel('Tset')
ylabel('dT/h')

%promt time calc
prompt = 'Do you want to calculate time?(1/0)(hit 0, not yet implementet))';
time = input(prompt);

if time == 1
    %promt density
    prompt = 'What is the density?';
    density = input(prompt);
    
    %promt density
    prompt = 'What is the weight?';
    weight = input(prompt);
    
    %calculate volume + height
    v = weight * density;   
    height = v / (pi*4^2);
    
    %calculate time
    %time = 
end
