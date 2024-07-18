function pltObsv(t, bds_arr, gps_arr, gln_arr, qzn_arr, gal_arr, pvt_arr)
    if(mod(t, 2) ~= 0)
        return;
    end
    L = size(bds_arr, 2);
    x = max(1, t-L+1):max(L, t);

    %% Plot satellite states
    subplot(131); hold off; plot(0); hold on;
    scatter(x, reshape(([bds_arr(:,:).Stat]>2), [64, L])'.*(1:64), 'r.');
    scatter(x, reshape(([gps_arr(:,:).Stat]>2), [32, L])'.*(65:96), 'm.');
    scatter(x, reshape(([qzn_arr(:,:).Stat]>2), [ 4, L])'.*(97:100), 5, 'mo');
    scatter(x, reshape(([gln_arr(:,:).Stat]>2), [24, L])'.*(101:124), 'b.');
    scatter(x, reshape(([gal_arr(:,:).Stat]>2), [30, L])'.*(125:154), 'g.');
    yticks([1, 65, 97, 101, 125]);
    axis([min(x), max(x), 1, 154]);
    grid on;
    drawnow

    %% Plot sky view
    subplot(232); hold off; plot(0); hold on;
    phi = reshape([bds_arr(:,:).El]/180*pi, [1, 64*L]);
    theta = reshape([bds_arr(:,:).Az]/180*pi, [1, 64*L]);
    scatter(cos(phi).*sin(phi), cos(phi).*sin(theta), 108, 'r.');
    phi = reshape([gps_arr(:,:).El]/180*pi, [1, 32*L]);
    theta = reshape([gps_arr(:,:).Az]/180*pi, [1, 32*L]);
    scatter(cos(phi).*sin(phi), cos(phi).*sin(theta), 108, 'm.');
    phi = reshape([qzn_arr(:,:).El]/180*pi, [1, 4*L]);
    theta = reshape([qzn_arr(:,:).Az]/180*pi, [1, 4*L]);
    scatter(cos(phi).*sin(phi), cos(phi).*sin(theta), 18, 'mo');
    phi = reshape([gln_arr(:,:).El]/180*pi, [1,24*L]);
    theta = reshape([gln_arr(:,:).Az]/180*pi, [1,24*L]);
    scatter(cos(phi).*sin(phi), cos(phi).*sin(theta), 108, 'b.');
    phi = reshape([gal_arr(:,:).El]/180*pi, [1,30*L]);
    theta = reshape([gal_arr(:,:).Az]/180*pi, [1,30*L]);
    scatter(cos(phi).*sin(phi), cos(phi).*sin(theta), 108, 'g.');

    theta = 0:pi/36:2*pi;
    plot(cos(theta), sin(theta), 'LineWidth', 0.5, 'Color', [0.6 0.6 0.6]);
    scatter(0.866*cos(theta), 0.866*sin(theta), 1, [0.8 0.8 0.8]);
    scatter(0.500*cos(theta), 0.500*sin(theta), 1, [0.8 0.8 0.8]);
    plot([-1, 1], [0, 0], 'LineWidth', 0.5, 'Color', [0.6 0.6 0.6]);
    plot([0, 0], [-1, 1], 'LineWidth', 0.5, 'Color', [0.6 0.6 0.6]);
    drawnow

    %% Plot CNR
    subplot(4,3,8);
    plot(1:L, reshape([bds_arr(:,:).CNR], [64, L])');
    axis([1, L, 5, 65]);
    grid on;
    subplot(4,3,11);
    plot(1:L, reshape([gps_arr(:,:).CNR], [32, L])');
    axis([1, L, 5, 65]);
    grid on;
    drawnow

    %% Plot PVT
    subplot(3,6,5);
    plot(x, [pvt_arr.Lat]); xlim([max(1, t-L+1),max(L, t)]);
    subplot(3,6,6);
    plot(x, [pvt_arr.Lon]); xlim([max(1, t-L+1),max(L, t)]);
    vel = reshape([pvt_arr.Vel], [1, 2*L]);
    subplot(3,6,11);
    plot(x, vel(1:2:2*L)); xlim([max(1, t-L+1),max(L, t)]);
    subplot(3,6,12);
    plot(x, vel(2:2:2*L)); xlim([max(1, t-L+1),max(L, t)]);
    subplot(3,3,9);
    plot(x, [pvt_arr.Time]); xlim([max(1, t-L+1),max(L, t)]);
    drawnow
end

