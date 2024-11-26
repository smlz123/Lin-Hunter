import matlab
import matlab.engine

import os
import paramiko

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())


hostname = '192.168.1.181'
username = 'user'
password = 'qaz@123'

ssh.connect(hostname, username=username, password=password)
cmd = 'rm -rf /home/user/Verilog_hdlsrc'
stdin, stdout, stderr = ssh.exec_command(cmd)
error = stderr.read().decode('utf-8')

eng = matlab.engine.start_matlab()
folder_path = "E:\\FPGA\\firstversion\\COMBAT-master\\COMBAT-master"
eng.addpath("E:\\FPGA\\firstversion\\COMBAT-master\\COMBAT-master")
eng.cd("E:\\FPGA\\firstversion\\COMBAT-master\\COMBAT-master")
eng.run('covexp.covcollect', nargout=0)
eng.run('emi.go()', nargout=0)

Save_name = eng.workspace['emi_stmp']
print(Save_name)
print('execute ssh remote power shell')

# cmd = 'mkdir /doc/zgl/resamplesource/Verilog_hdlsrc'
# stdin, stdout, stderr = ssh.exec_command(cmd)

# cmd = 'cp -r /home/user/Verilog_hdlsrc /doc/zgl/resamplesource/Verilog_hdlsrc'
# stdin, stdout, stderr = ssh.exec_command(cmd)


# output = stdout.read().decode('utf-8')
# error = stderr.read().decode('utf-8')

# if error:
#     print("Error:", error)
# else:
#     print("Output:", output)

cmd = 'cd /doc/xzh \n'+'/home/user/anaconda3/envs/xzh/bin/python3.9 /doc/zgl/test_main.py'
stdin, stdout, stderr = ssh.exec_command(cmd)


output = stdout.read().decode('utf-8')
error = stderr.read().decode('utf-8')

if error:
    print("Error:", error)
else:
    print("Output:", output)
