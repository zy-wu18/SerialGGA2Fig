function pvt_arr = rmc2pvtobsv(nmea_data)
    pvt_arr = struct("Lat", NaN, "Lon", NaN, "Time", NaT, "Vel", [NaN, NaN]);
    pvt_arr.Time = datetime;
    nmea_data = str2double(nmea_data);
    yMd = nmea_data(9);
    pvt_arr.Time.Day  = floor(yMd/1e4);
    pvt_arr.Time.Month= floor(mod(yMd, 1e4)/1e2);
    pvt_arr.Time.Year = 2000+floor(mod(yMd, 1e2));
    tod = nmea_data(1);
    pvt_arr.Time.Hour = floor(tod/1e4);
    pvt_arr.Time.Minute=floor(mod(tod, 1e4)/1e2);
    pvt_arr.Time.Second=floor(mod(tod, 1e2));
    pvt_arr.Lat = (nmea_data(3))/100;
    pvt_arr.Lon = (nmea_data(5))/100;
    pvt_arr.Vel(1) = nmea_data(7);
    pvt_arr.Vel(2) = nmea_data(8);
end

