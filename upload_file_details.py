
import paramiko

def upload_via_sftp(local_path, remote_path, hostname, port, username, password):
    print(f"hostname = {repr(hostname)}")
    print(f"port = {repr(port)}")
    print(f"username = {repr(username)}")
    print(f"local_path = {repr(local_path)}")
    print(f"remote_path = {repr(remote_path)}")
    # Initialize the SSH client
    ssh = paramiko.SSHClient()
    
    # Automatically add the remote server's SSH key (useful for trusted networks)
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    
    try:
        # Connect to the remote server
        ssh.connect(hostname=hostname, port=port, username=username, password=password)
        
        # Open an SFTP session
        sftp = ssh.open_sftp()
        
        # Upload the local file to the destination path
        sftp.put(local_path, remote_path)
        print("Upload successful!")
        
        # Clean up the session
        sftp.close()
    except Exception as e:
        print(f"An error occurred: {e}")
    finally:
        ssh.close()

#Example Usage
# upload_via_sftp(
#     local_path="D:\\Autobots\\EB_EASYPAISA_ENG.png",
#     remote_path="B_EASYPAISA_ENG.png",
#     hostname="192.168.1.139",
#     port=22,
#     username="amna",
#     password="amna@001"
# )