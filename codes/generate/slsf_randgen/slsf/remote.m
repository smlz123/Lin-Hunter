function ret = remote(src)
ftpobj = ftp('192.168.31.36', 'user', 'qaz@123');
try
    uploard_src = [src,'\Verilog_hdlsrc'];
    mput(ftpobj, uploard_src);
    close(ftpobj);
    disp('****======= upload successful =======****')
    ret = 1;
catch
    disp('There are some errors in uploading please check your config')
end
end