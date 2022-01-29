file1=tech_st_Jan2122.tar.gz
cd /u02/CLONE_HOME/ADMS08
sftp sahasnn@UQ00392P <<EOF
cd /u02/CLONE_HOME
mget $file1
bye
EOF
