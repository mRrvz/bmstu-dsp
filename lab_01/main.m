function main()
% Исходные параметры
sigma = 5;
tt = 2;
n = 20;
dt = 1;
t_max = dt*(n-1)/2;

% Дискретные сигналы
t = -t_max:dt:t_max; 
gaussian_discrete = exp(-(t/sigma).^2);
rectangle_discrete = zeros(size(t));
rectangle_discrete(abs(t) - tt < 0) = 1;

% Исходные сигналы
x = -t_max:0.005:t_max;
gaussian_initial = exp(-(x/sigma).^2);
rectangle_initial = zeros(size(x));
rectangle_initial(abs(x) - tt < 0) = 1;

% Восстановленные сигналы
gaussian_restored = zeros(1, length(x));
rectangle_restored = zeros(1, length(x));
for i=1:length(x)
   for j = 1:n
       gaussian_restored(i) = gaussian_restored(i) + gaussian_discrete(j) * sin((x(i)-t(j))/dt * pi) / ((x(i)-t(j))/dt * pi);
       rectangle_restored(i) = rectangle_restored(i) + rectangle_discrete(j) * sin((x(i)-t(j))/dt * pi) / ((x(i)-t(j))/dt * pi);
   end
end

figure;

subplot(2,1,1);
title('Импульс прямоугольника');
hold on;
grid on;
plot(x, rectangle_initial, 'k');
plot(x, rectangle_restored, 'g');
plot(t, rectangle_discrete, '.r');
legend('Исходный', 'Востановленный', 'Дисркетный');

subplot(2,1,2);
title('Гаусс');
hold on;
grid on;
plot(x, gaussian_initial, 'k');
plot(x, gaussian_restored, 'g');
wait = plot(t, gaussian_discrete, '.r');
legend('Исходный', 'Востановленный', 'Дискретный');
waitfor(wait);
end