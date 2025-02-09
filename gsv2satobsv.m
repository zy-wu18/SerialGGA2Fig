function sat_arr = gsv2satobsv(nmea_data, prn_range, sat_arr_i)
    if(nargin == 3)
        sat_arr = sat_arr_i;
    else
        satobsv = struct("Stat", 0, "El", NaN, "Az", NaN, "CNR", NaN);
        sat_arr = repmat(satobsv, [prn_range(2)-prn_range(1)+1, 1]);
    end
    nmea_data = str2double(nmea_data);
    for n = 4:4:(4*(min(4, nmea_data(3)-4*(nmea_data(2)-1))+1)-1)
        if(nmea_data(n) > prn_range(2) || nmea_data(n) < prn_range(1))
            continue;
        end
        prn = nmea_data(n) - prn_range(1) + 1;
        sat_arr(prn).El = nmea_data(n+1);
        sat_arr(prn).Az = nmea_data(n+2);
        sat_arr(prn).CNR= nmea_data(n+3);
        if(~isnan(nmea_data(n+3)))
            sat_arr(prn).Stat = 3; % CNR available
        elseif(~isnan(nmea_data(n+1)))
            sat_arr(prn).Stat = 2; % El/Az available
        else
            sat_arr(prn).Stat = 1; % Trying to acquire
        end
    end
end

