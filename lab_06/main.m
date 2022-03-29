function main
    pkg load statistics

    sigma = 0.5;
    range = 5;
    step = 0.005;
    t = -range:step:range;

    initial_signal = exp(-(t / sigma).^2); % gauss

    gn_mu = 0;
    gn_sig = 0.05;
    gauss_noise = normrnd(gn_mu, gn_sig, [1 length(initial_signal)]);
    with_gauss_noise = initial_signal + gauss_noise;

    count = 4 + unidrnd(2,1,1);
    intensity = max(initial_signal) / 3;
    impulse_noise = imp_noise(length(initial_signal), count, intensity);
    with_impulse_noise = initial_signal + impulse_noise;

    wiener_gauss = wiener(fft(with_gauss_noise), fft(gauss_noise));
    wiener_impulse = wiener(fft(with_impulse_noise), fft(impulse_noise));


    subplot(2,1,1)
    wait = plot(t, with_impulse_noise);
    legend('C помехами');
    subplot(2,1,2)
    plot(t, ifft(fft(with_impulse_noise).*wiener_impulse));
    legend('С фильтром');
    title('Фильтрация импульсной помехи фильтром Винера');

    figure(2)
    subplot(2,1,1)
    plot(t, with_gauss_noise)
    legend('C помехами');
    subplot(2,1,2)
    plot(t, ifft(fft(with_gauss_noise).*wiener_gauss));
    legend('С фильтром');
    title('Фильтрация помехи Гаусса фильтром Винера');

    waitfor(wait)
end

function y = imp_noise(range, N, intensity)
    step = floor(range / N);
    y = zeros(1, range);
    for i = 1:N
        y(i * step) = intensity;
    end
end

function cleaned = wiener(signal, noise)
    cleaned = 1 - (noise./signal).^2;
end