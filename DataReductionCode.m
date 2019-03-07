%==========================================================================
% Name: Jake McCann
% Date: 3/4/19
% Class: Engineering 1182
% 
% Program Title: Performance Analaysis
%
% Program Description: Data reduction code that graphs various values
% in order to compare script effeciency
%==========================================================================
clc; clear;
% Load EEPROM data into MATLAB workspace
data = xlsread('perfomance_analysis_1.xlsx');
max_case = data(:,1);

% mass
m = input('Enter mass of AEV: ');

% loop ends after entire file has been parsed through
b = 1;
for i = 7:length(max_case)

    %Seperates data from EEPROM data by column not in physical parameters
    bot_time = data(i,1);
    bot_current = data(i,2);
    bot_voltage = data(i,3);
    bot_marks_sum = data(i,4);
    bot_marks_pos = data(i,5);
    
    %Equations to convert EEPROM data to physical parameters
    %time 
    if bot_time>0
        t(b) = bot_time/1000;
    else
        t(b) = 0;
    end
    %current
    if bot_current > 0 
        I(b) = (bot_current/1024)*2.46/ 0.185;
    else
        I(b) = 0;
    end
    %voltage
    if bot_voltage > 0
        V(b) = (15*bot_voltage)/1024;
    else
        V(b) = 0;
    end
    %distance
    d(b) = 0.0124 * bot_marks_sum;
    %position 
    s(b) = 0.0124 * bot_marks_pos;
    %power
    P(b) = V(b) * I(b);
    
    b = b+1;
end


for b = 1:length(t)
    if b+1 < length(t)
        %incremental energy
        IE(b) = ((P(b)+P(b+1))/2)*(t(b+1)-t(b));
    else
        IE(b) = 0;
    end
    
    if b-1>1
        %velocity
        v(b) = (s(b)-s(b-1))/(t(b)-t(b-1));
        %kinetic energy
        KE(b) = 1/2 * m * v(b)^2;
    else
        v(b) = 0;
        KE(b) = 0;
    end
    
 
    RPM(b) = -64.59*I(b)^2+1927.25*I(b)-84.58;
    %propeller advance radio
    J(b) = v(b)/((RPM(b)/60)*0.0762);
    
    if J(b) < 0.15 && P(b) == 0
        J(b) = 0;
    elseif J(b) < 0.15 && P(b) ~= 0
        J(b) = 0.15;
    end
    
    pe(b) = -454.37*J(b)^3+321.58*J(b)^2+22.603*J(b);
    
    ETotal(b) = sum(IE);
end

%plots supplied power by time
subplot(1,2,1);
plot(t,P);
title('Power Versus Time');
xlabel('Time (seconds)');
ylabel('Power (Watts)');
grid on


subplot(1,2,2);
plot(t,P);
title('Phases ')
xlabel('Time (seconds)');
ylabel('Power (Watts)');
grid on

figure;
%plots supplied power by distance
subplot(1,2,1);
plot(d,P);
title('Power Versus Distance');
xlabel('Distance (meters)');
ylabel('Power (Watts)');
grid on

subplot(1,2,2);
plot(d,P);
title('Phases')
xlabel('Distance (meters)');
ylabel('Power (Watts)');
grid on

figure;
%plots velocity by distance
subplot(1,2,1);
plot(d,v);
title('Velocity Versus Distance');
xlabel('Distance (meters)');
ylabel('Velocity (m/s)');
grid on

subplot(1,2,2);
plot(d,v);
title('Phases')
xlabel('Distance (meters)');
ylabel('Velocity (m/s)');
grid on

figure;
%plots kinetic energy by distance
subplot(1,2,1);
plot(d,KE);
title('Kinetic Energy Versus Distance');
xlabel('Distance (meters)');
ylabel('Kinetic Energy (joules)');
grid on

subplot(1,2,2);
plot(d,KE);
title('Phases')
xlabel('Distance (meters)');
ylabel('Kinetic Energy (joules)');
grid on

figure;
%plots propultion efficiency by distance
subplot(1,2,1);
plot(d,pe);
title('Propulsion Efficiency Versus Distance');
xlabel('Distance (meters)');
ylabel('Propulsion Efficiency');
grid on

subplot(1,2,2);
plot(d,pe);
title('Phases')
xlabel('Distance (meters)');
ylabel('Propulsion Efficiency');
grid on

%finds energy usage of each phase
phase1 = ETotal(85);
phase2 = ETotal(292)-ETotal(85);
phase3 = ETotal(501)- ETotal(292)-ETotal(85);





