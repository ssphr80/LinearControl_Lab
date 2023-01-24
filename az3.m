clear; clc; clf
set(0, 'DefaultLineLineWidth', 2);
%%
with_feedback = true;
with_controler = true;
%%

R = 10e3;
C = 10e-6;

taw = R*C;

s = tf('s');
G = 1 / ((taw^2)*s^2 + 3*taw*s + 1);

t_end = 2.5;
[y_op, t] = step(G, t_end);

u = ones(size(t));
figure(1); clf; hold on; grid on

plot(t, u, 'r--', 'displayName', 'ref')
plot(t, y_op, 'displayName', 'open loop')

KP = 10;
KI = KP* (1 / (10e3 * 10e-6));
KD = KP* (10e3 * 10e-6);

C = pid(KP);
H = feedback(G*C, 1);
[yc, t] = step(H, t_end);
plot(t, yc, 'g', 'displayName', ['with P controler', ' P=', num2str(C.Kp)])

C = pid(KP, KI);
H = feedback(G*C, 1);
[yc, t] = step(H, t_end);
plot(t, yc, 'm', 'displayName', ['with PI controler', ' Ki=', num2str(C.Ki)])


C = pid(KP, KI, KD);
H = feedback(G*C, 1);
[yc, t] = step(H, t_end);
plot(t, yc, 'k', 'displayName', ['with PID controler', ' Kd=', num2str(C.Kd)])

title('Step Response');
xlabel('Time (seconds)'); ylabel('Amplitude');
legend('show')


%% ###################################
% t_end = 2.5;
% s = tf('s');
% 
% taw=0.1 ; zita=0.2;
% 
% G = (1) / (taw*s*(taw*s+2*zita));
% G = feedback(G, 1);
% 
% [y_op, t] = step(G, t_end);
% u = ones(size(t));
% hold on
% title_ = {['\tau : ', num2str(taw), ' ,  \xi: ', num2str(zita)]};
% plot(t, u, 'k--', 'displayName', 'ref')
% plot(t, y_op, 'displayName', 'open loop')
% 
% if with_feedback
%     H = feedback(G, 1);
%     [y_cl, t] = step(H, t_end);
%     plot(t, y_cl, 'displayName', 'closed loop')
% end
% 
% if with_controler
    opt = pidtuneOptions('DesignFocus', 'disturbance-rejection');
    [C, info ] = pidtune(G, 'pid')
    C.Kp;
    Ti = C.Kp / C.Ki;
    Td = C.Kd / C.Kp;
    H = feedback(G*C, 1);
%     
%     [yc, t] = step(H, t_end);
%     plot(t, yc, 'b--', 'displayName', 'with PID controler')
%     title_ = {title_{:}, ['PID: K_p: ', num2str(C.Kp), ', T_i: ', num2str(Ti), ', T_d: ', num2str(Td)]};
% end
% title(title_);
% legend('show')
% grid on