function pltObsv(t, bds_arr, gps_arr, gln_arr, qzn_arr, gal_arr, pvt_arr)
    L = size(bds_arr, 2);
    x = max(1, t-L+1):max(L, t);

    %% Plot satellite states
    subplot(131); hold off; plot(0); hold on;
    scatterArrStat(x, bds_arr, 0, 20, 'r.');
    scatterArrStat(x, gps_arr, 64, 20, 'm.');
    scatterArrStat(x, qzn_arr, 96, 5, 'mo');
    scatterArrStat(x, gln_arr, 100, 20, 'b.');
    scatterArrStat(x, gal_arr, 124, 20, 'g.');
    yticks([1, 65, 97, 101, 125]);
    axis([min(x), max(x), 1, 154]);
    grid on; title("Satellite availablility");
    drawnow

    %% Plot sky view
    subplot(232); hold off; plot(0); hold on;
    theta = 0:pi/36:2*pi;
    plot(cos(theta), sin(theta), 'LineWidth', 0.5, 'Color', [0.6 0.6 0.6]);
    scatter(0.667*cos(theta), 0.667*sin(theta), 1, [0.8 0.8 0.8]);
    scatter(0.333*cos(theta), 0.333*sin(theta), 1, [0.8 0.8 0.8]);
    plot([-1, 1], [0, 0], 'LineWidth', 0.5, 'Color', [0.6 0.6 0.6]);
    plot([0, 0], [-1, 1], 'LineWidth', 0.5, 'Color', [0.6 0.6 0.6]);
    scatterArrElAz2Polar(bds_arr, 'C', 108, 'r.');
    scatterArrElAz2Polar(gps_arr, 'G', 108, 'm.');
    scatterArrElAz2Polar(qzn_arr, 'Q',  18, 'mo');
    scatterArrElAz2Polar(gln_arr, 'R', 108, 'b.');
    scatterArrElAz2Polar(gal_arr, 'E', 108, 'g.');
    title("Satellite skyplot");
    drawnow

    %% Plot CNR
    subplot(4,3,8);
    plot(1:L, reshape([bds_arr(:,:).CNR], [64, L])');
    axis([1, L, 5, 65]);
    grid on; title("BDS CNR");
    subplot(4,3,11);
    plot(1:L, reshape([gps_arr(:,:).CNR], [32, L])');
    axis([1, L, 5, 65]);
    grid on; title("GPS CNR");
    drawnow

    %% Plot PVT
    subplot(3,6,5); plot(x, [pvt_arr.Lat]); 
    xlim([max(1, t-L+1),max(L, t)]); title("Latitude(deg)");
    subplot(3,6,6); plot(x, [pvt_arr.Lon]); 
    xlim([max(1, t-L+1),max(L, t)]); title("Longitude(deg)");
    vel = reshape([pvt_arr.Vel], [1, 2*L]);
    subplot(3,6,11); plot(x, vel(1:2:2*L)); 
    xlim([max(1, t-L+1),max(L, t)]); title("Speed(km/h)");
    subplot(3,6,12); plot(x, vel(2:2:2*L)); 
    xlim([max(1, t-L+1),max(L, t)]); title("Heading(deg)");
    subplot(3,3,9); plot(x, [pvt_arr.Time]);
    xlim([max(1, t-L+1),max(L, t)]); title("GNSS Time");
    drawnow
end

function scatterArrElAz2Polar(s_arr, abbr, mksize, marker)
    n = size(s_arr, 1);
    L = min(20, size(s_arr, 2));
    phi = reshape(1.0-[s_arr(:,end-L+1:end).El]/90, [n, L]);
    theta = reshape((-[s_arr(:,end-L+1:end).Az]+90)/180*pi, [n, L]);
    for i = 1:n
        if(all(isnan(phi(i, :))))
            continue;
        end
        x = phi(i,:).*cos(theta(i,:));
        y = phi(i,:).*sin(theta(i,:));
        scatter(x, y, mksize, marker);
        text(x(end), y(end), sprintf("%c%02d", abbr, i), "FontSize", 8);
    end
end

function scatterArrStat(x, s_arr, b, mksize, marker)
    n = size(s_arr, 1);
    L = size(s_arr, 2);
    stat = reshape(([s_arr(:,:).Stat]>2), [n, L]).*(b+(1:n))';
    for i = 1:size(stat, 1)
        if(~isempty(find(stat(i, :), 1)))
            scatter(x, stat(i, :), mksize, marker);
        end
    end
end