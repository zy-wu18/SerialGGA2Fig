function serialnmea2fig(s, fig)
    if(nargin == 1)
        figure('Position', [100, 100, 1024, 640], 'Name', 'SerialNmea2Fig', 'NumberTitle', 'off');
    elseif(nargin == 2)
        set(fig, "Position", [100, 100, 1024, 640]);
    end
    SatObsv = struct("Stat", 0, "El", NaN, "Az", NaN, "CNR", NaN);
    PvtObsv = struct("Lat", NaN, "Lon", NaN, "Time", NaT, "Vel", [NaN, NaN]);
    win_len = 60;
    i = 1;
    t = 1;
    bds_arr = repmat(SatObsv, [64, win_len]);
    gps_arr = repmat(SatObsv, [32, win_len]);
    gln_arr = repmat(SatObsv, [24, win_len]);
    qzn_arr = repmat(SatObsv, [ 4, win_len]);
    gal_arr = repmat(SatObsv, [30, win_len]);
    pvt_arr = repmat(PvtObsv, [ 1, win_len]);
    
    while(1)
        try
            line = readline(s);
        catch WE
            fprintf(WE.identifier);
            s.delete;
            break;
        end
        if(~startsWith(line, '$'))
            continue;
        end
        nmea_words = strsplit(line, ',', 'CollapseDelimiters', false);
        nmea_type = nmea_words(1);
        nmea_data = nmea_words(2:end-1);
        switch(nmea_type)
            case '$GBGSV' % BDS
                bds_arr(:, i) = gsv2satobsv(nmea_data, [1, 64]);
            case '$GPGSV' % GPS
                gps_arr(:, i) = gsv2satobsv(nmea_data, [1, 32]);
            case '$GQGSV' % QZSS
                qzn_arr(:, i) = gsv2satobsv(nmea_data, [1,  4]);
            case '$GLGSV' % GLONASS
                gln_arr(:, i) = gsv2satobsv(nmea_data, [65,88]);
            case '$GAGSV' % Galileo
                gal_arr(:, i) = gsv2satobsv(nmea_data, [1, 30]);
            case '$GNRMC' % Recommanded compressed PVT
                t = t + 1;
                if(i + 1 > win_len)
                    pvt_arr(end) = rmc2pvtobsv(nmea_data);
                    bds_arr(:, 1:end-1) = bds_arr(:, 2:end);
                    gps_arr(:, 1:end-1) = gps_arr(:, 2:end);
                    gln_arr(:, 1:end-1) = gln_arr(:, 2:end);
                    qzn_arr(:, 1:end-1) = qzn_arr(:, 2:end);
                    gal_arr(:, 1:end-1) = gal_arr(:, 2:end);
                    pvt_arr(1:end-1) = pvt_arr(2:end);
                else
                    pvt_arr(i) = rmc2pvtobsv(nmea_data);
                    i = i + 1;
                end
                
                pltObsv(t, bds_arr, gps_arr, gln_arr, qzn_arr, gal_arr, pvt_arr);
            %case '$GNGGA'
            %case '$GNZDA' % Zulu-time & DAte
            otherwise %do nothing
        end
        
    end

    s.delete;
end