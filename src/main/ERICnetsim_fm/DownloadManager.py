import urllib2
import ftplib

class DownloadManager:

    save_filename = ''

    def download_http_file(self, url, save_filename):
        try:
            response = urllib2.urlopen(url)
            data = response.read()
            fout = open(save_filename, "wb")
            fout.write(data)
            fout.close()
        except Exception, e:
            print 'Unable to download ' + url

    def download_ftp_file(self, url, username, password, directory, filename):
        try:
            ftp = ftplib.FTP(url)
            ftp.login(username, password)
            ftp.cwd(directory)
            f = open(filename, 'wb')
            ftp.retrbinary("RETR " + file,f.write)
            f.close()
        except Exception, e:
            print 'Unable to download ' + filename +  ' from ' + url

    def upload_ftp_file(self, server, username, password, directory, filename):
	try:
	   ftp = ftplib.FTP(server, username, password)
	   f = open(filename, 'rb')
	   ftp.storbinary('STOR ' + filename, f)
	   f.close()
           ftp.quit()
	except Exception, e:
	   print 'Unable to upload file ' + filename
	   print e
