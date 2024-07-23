clear variables; close all; fclose all;

spl = serialportlist("available");
spl = sort(spl, "ascend");
s = serialport(spl(end), 921600);
configureTerminator(s, 'CR/LF');
writeline(s, 'gnss --debug on');
fig = figure('Name', 'SerialNmea2Fig', 'NumberTitle', 'off');

try
    serialnmea2fig(s, fig);
catch ME
    s.delete;
    rethrow(ME);
end
