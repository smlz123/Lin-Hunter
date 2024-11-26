import matlab
import matlab.engine
import ast

import os
import paramiko
import socket
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.setsockopt(socket.SOL_SOCKET, socket.SO_SNDBUF, 2048)
s.setsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF, 2048)
def HDL_generate():

#def add_folders_to_path(eng, folder):
 #   eng.addpath(folder)
  #  for subdir, dirs, files in os.walk(folder):
   #     for dir in dirs:
    #        path = os.path.join(subdir, dir)
     #       eng.addpath(path)

    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())


    hostname = '192.168.1.181'
    username = 'user'
    password = 'qaz@123'

    ssh.connect(hostname, username=username, password=password)
    cmd = 'rm -rf /home/user/Verilog_hdlsrc'
    stdin, stdout, stderr = ssh.exec_command(cmd)
    error = stderr.read().decode('utf-8')
    try:
        eng = matlab.engine.start_matlab()
        folder_path = "E:\\FPGA\\firstversion\\COMBAT-master\\COMBAT-master"
        eng.addpath("E:\\FPGA\\firstversion\\COMBAT-master\\COMBAT-master")
        eng.cd("E:\\FPGA\\firstversion\\COMBAT-master\\COMBAT-master")
        eng.run('covexp.covcollect', nargout=0)
        eng.run('emi.go()', nargout=0)
        folder_path = "E:\\FPGA\\firstversion\\generate\\slsf_randgen\\transport.m"
        eng.addpath("E:\\FPGA\\firstversion\\generate\\slsf_randgen\\transport.m")
        eng.cd("E:\\FPGA\\firstversion\\generate\\slsf_randgen\\transport.m")
        eng.run('transport.m', nargout=0)
        folder_path = path = "E:\\FPGA\\firstversion\\generate\\slsf_randgen\\slsf"     # your slsf adress
        #add_path_cmd = 'addpath(genpath('+folder_path+')'
        #add_folders_to_path(eng, folder_path)
        eng.addpath(path="E:\\FPGA\\firstversion\\generate\\slsf_randgen\\slsf")
        eng.cd(path="E:\\FPGA\\firstversion\\generate\\slsf_randgen\\slsf")
        eng.run('addpath_GUIDANCE.m', nargout=0)
        eng.run('Hdl_generation.m', nargout=0)
        Save_name = eng.workspace['stmp']
    finally:
        eng.quit()
    print(Save_name)
    print('execute ssh remote power shell')



    cmd = 'mkdir /doc/xzh/resamplesource/'+Save_name
    stdin, stdout, stderr = ssh.exec_command(cmd)


    cmd = 'cp -r /home/user/Verilog_hdlsrc /doc/xzh/resamplesource/'+Save_name+'/Verilog_hdlsrc'
    stdin, stdout, stderr = ssh.exec_command(cmd)


    output = stdout.read().decode('utf-8')
    error = stderr.read().decode('utf-8')

    if error:
        print("Error:", error)
    else:
        print("Output:", output)

    cmd = 'cd /doc/xzh \n'+'/home/user/anaconda3/envs/xzh/bin/python3.9 /doc/xzh/test_main.py'
    stdin, stdout, stderr = ssh.exec_command(cmd)


    output = stdout.read().decode('utf-8')
    error = stderr.read().decode('utf-8')

    if error:
        print("Error:", error)
    else:
        print("Output:", output)


def get_reward():
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    hostname = '192.168.1.181'
    username = 'user'
    password = 'qaz@123'
    ssh.connect(hostname, username=username, password=password)
    cmd = 'cd /doc/xzh \n' + '/home/user/anaconda3/envs/xzh/bin/python3.9 /doc/xzh/Find.py'
    stdin, stdout, stderr = ssh.exec_command(cmd)
    output = stdout.read().decode('utf-8')
    error = stderr.read().decode('utf-8')
    print(error)
    output = ast.literal_eval(output.strip())
    return output
